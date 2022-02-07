#Created By:
#Lucas Iago Soares da Silva
# luhiago@hotmail.com
#
#     IF YOU HAVE ANY QUESTIONS, PLEASE CONTACT ME 
# 
# ATTENTION, THIS SCRIPT MAKES CHANGES IN YOUR ORGANIZATION, PLEASE CHECK BEFORE RUNNING


$users = gc 'C:\temp\users.txt' #USER LIST - CREATE TXT ON C:\TEMP
# OR RUN (NEXT CMDLET COLLECT AND EXPORT ALL ORGANIZATION USERS):
#CMDLET:   Get-MsolUser -all |select UserPrincipalName > c:\temp\users.txt

# User have license variable
$Global:verifylicense = Get-MsolUser -UserPrincipalName $global:user.Replace(' ' , '') |Select DisplayName,IsLicensed,UserPrincipalName

# PromptLanguage Consult
$global:consultbefore = Get-CsOnlineVoicemailUserSettings -Identity $global:user.Replace(' ' , '') |select PromptLanguage


#######################
## LOGIN CMDLET AREA ##
#######################

#$Cred = Get-Credential 
#Connect-AzAccount -Credential $Cred
#Connect-MsolService -credential $Cred
#Connect-MicrosoftTeams -Credential $Cred

#Start code 
    $Report = [System.Collections.Generic.List[Object]]::new() #PS OBJECT 
 foreach ($global:user in $users) { 

      if ($Global:verifylicense -ilike "*True*") {
        if ($global:consult.PromptLanguage -ilike "en-US") {
          
         # if ($global:consult.PromptLanguage -ilike "pt-BR") {
            Set-CsOnlineVoicemailUserSettings -PromptLanguage "pt-BR" -Identity $global:user.Replace(' ' , '')
            $global:consultafter = Get-CsOnlineVoicemailUserSettings -Identity $global:user.Replace(' ' , '') |select PromptLanguage
           
        } #End Second IF 
      } #End First IF
      
      Write-Host $global:user.Replace(' ' , '')
      $Global:verifylicense.IsLicensed
      $global:consultbefore.PromptLanguage 
      $global:consultafter 
    
      #REPORT CMDLETS
     $ReportLine = [PSCustomObject] @{
            User = $global:user.Replace(' ' , '')
            PromptLanguagebefore = $global:consultbefore.PromptLanguage
            PromptLanguageafter = $global:consultafter.PromptLanguage
            License = $Global:verifylicense.IsLicensed
}

$Report.Add($ReportLine)

  } #foreach
  $Report |Select User, PromptLanguagebefore, PromptLanguageafter, License |Sort Name | Out-GridView
 
  $Report |sort Name | Export-CSV -NoTypeInformation c:\temp\change.csv
