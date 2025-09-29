$title Nonlinear Stochastic Production Planning Model (Crude 1 Supply ~ N(300,20^2))

sets
    t        "Weeks"   /1, 2, 3/      
    crude     "Crude oil types"  /1, 2/ 
;

parameters
    cost_crude(crude)   "Cost per unit of crude oil"                /1 500, 2 600/
    sell_price_A        "Selling price of product A"                /1000/
    sell_price_B        "Selling price of product B"                /740/   
    conv_crude_A(crude) "Conversion rate to A in crude converter"   /1 0.5, 2 0.7/
    conv_crude_B(crude) "Conversion rate to B in crude converter"   /1 0.3, 2 0.2/
    conv_crude_C(crude) "Conversion rate to C in crude converter"   /1 0.2, 2 0.1/
    conv_recon_B        "Conversion rate of B to A in reconverter"  /0.9/
    conv_recon_C        "Conversion rate of C to A in reconverter"  /0.4/
    storage_cost        "Storage cost per unit of B"                /20/
    converter_cost      "Running cost per unit in crude converter"  /100/
    reconverter_cost    "Running cost per unit in reconverter"      /80/
    crude_limit(crude)  "Max purchase limit per week for crude"     /1 300, 2 300/
    converter_cap       "Max capacity of crude converter per week"  /500/
    reconverter_cap     "Max capacity of reconverter per week"      /300/
    A_sales_cap         "Max sales limit for A per week"            /250/
    B_sales_cap(t)      "Max sales limit for B per week"            /1 30, 2 130, 3 130/
    mu_crude1          "Mean supply of Crude 1"                     /300/
    sigma_crude1       "Std deviation of Crude 1"                   /20/
;



variables
    profit                                              Total expected profit
    x(crude, t)                                         Units of crude purchased
    yA(t)                                               Units of product A sold
    yB(t)                                               Units of product B sold
    sB(t)                                               Units of product B stored at end of week
    rB(t)                                               Units of product B sent to reconverter
    rC(t)                                               Units of product C sent to reconverter
;

positive variables x, yA, yB, sB, rB, rC;
*--------------------------------------------------------------------
* Evaluating the expected value
* Mean and standard deviation of Crude 1 supply in each week
Parameter
   mu(t)    "Mean supply of Crude 1"
   sigma(t) "St.Dev. of Crude 1";

mu("1")    = 300;  sigma("1") = 20;
mu("2")    = 300;  sigma("2") = 20;
mu("3")    = 300;  sigma("3") = 20;
Scalar pi    / 3.141592653589793 /;
* <--- User-defined pi

Positive Variable
   z(t),
   pdf(t),
   cdf(t),
   eplus(t);

*Positive Variable x;
* or nonnegative, etc.

Equation defZ(t), defPdf(t), defCdf(t), defEplus(t);

defZ(t)..    z(t) =E= ( x("1",t) - mu(t) ) / sigma(t);

defPdf(t)..  pdf(t) =E= ( 1 / sqrt(2*pi) ) * exp( -0.5* sqr( z(t) ) );

defCdf(t)..  cdf(t) =E= 0.5 * ( 2 * errorf( z(t) ) );

defEplus(t).. eplus(t) =E= ( x("1",t) - mu(t) )*cdf(t) + sigma(t)*pdf(t);



*--------------------------------------------------------------------
equations
    objective                                           Objective function
    crude_purchase(crude, t)                           Crude purchase limit
    converter_capacity(t)                              Crude converter capacity
    A_sales(t)                                         Product A sales balance
    B_sales_limit(t)                                   Product B sales limit
    C_production(t)                                    Product C production
    B_balance(t)                                       Product B balance
    reconverter_capacity(t)                            Reconverter capacity
    final_storage                                      Final storage must be zero
;


* Nonlinear objective with expected shortage cost for Crude 1
objective.. profit =e= sum(t,
    sell_price_A * yA(t) + sell_price_B * yB(t)
    - (500 * x('1',t)
       + 200 * eplus(t)
       + cost_crude('2') * x('2',t)
       + converter_cost * sum(crude, x(crude, t))
       + reconverter_cost * (rB(t) + rC(t))
       + storage_cost * sB(t))
);

crude_purchase(crude, t).. x(crude, t) =l= crude_limit(crude);

converter_capacity(t).. sum(crude, x(crude, t)) =l= converter_cap;

A_sales(t).. yA(t) =e= sum(crude, conv_crude_A(crude) * x(crude, t)) 
                      + conv_recon_B * rB(t) + conv_recon_C * rC(t);

yA.up(t) = A_sales_cap;

B_sales_limit(t).. yB(t) =l= B_sales_cap(t);

C_production(t).. rC(t) =e= sum(crude, conv_crude_C(crude) * x(crude, t));

B_balance(t).. sum(crude, conv_crude_B(crude) * x(crude, t)) 
             + sB(t-1)$(ord(t) > 1) =e= yB(t) + rB(t) + sB(t);

reconverter_capacity(t).. rB(t) + rC(t) =l= reconverter_cap;

final_storage.. sB('3') =e= 0;

model stochastic_production /all/;

* Use a nonlinear solver (e.g., CONOPT, IPOPT)
option nlp=conopt;
solve stochastic_production using nlp maximizing profit;

display x.l, yA.l, yB.l, sB.l, rB.l, rC.l, profit.l;