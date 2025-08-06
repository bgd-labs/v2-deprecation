# V2 Deprecation

V2 Pool have phased out over the recent months and years.
As a final step, in line with the approach on v1, the close factor will be set to 100% allowing for a smooth cleanup of remaining debt positions without leaving dust.
In addition, the clinic steward originally introduced for Aave V3, will be extended for V2, to allow cleanup of bad debt positions.

If the reserve utilization is below uOptimal, uOptimal will be set to the reserve utilization.
This will increase the borrow rate within expected bounds and incentivize repayments.
