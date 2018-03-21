If ((Get-CimInstance win32_battery).batterystatus -eq 1)

  {

   $p = Get-CimInstance -Name rootcimv2power -Class win32_PowerPlan `

    -Filter "ElementName = 'Power Saver'"      

    Invoke-CimMethod -InputObject $p -MethodName Activate }

Elseif ((Get-CimInstance win32_battery).batterystatus -eq 3)

  {

   $p = Get-CimInstance -Name rootcimv2power -Class win32_PowerPlan `

    -Filter "ElementName = 'High performance'" 

    Invoke-CimMethod -InputObject $p -MethodName Activate }

Else

 {

   $p = Get-CimInstance -Name rootcimv2power -Class win32_PowerPlan `

    -Filter "ElementName = 'Balanced'"  

    Invoke-CimMethod -InputObject $p -MethodName Activate }