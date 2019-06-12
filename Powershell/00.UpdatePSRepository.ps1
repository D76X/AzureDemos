# Refs
# https://stackoverflow.com/questions/53358723/unable-to-find-repository-on-update-module

# ----------------------------------------
# might need to update the PSRepository in order to run the 
# update of modules installed on your machine. However, the 
# URI of teh Repomight have changed and be invalid thus it 
# must be updated.
Get-PSRepository # might show the old value 
Register-PSRepository -Name PSGallery1 -SourceLocation https://www.powershellgallery.com/api/v2/ -InstallationPolicy Trusted
# ----------------------------------------
