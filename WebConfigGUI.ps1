Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Load Application Names (Replace with a config file if needed)
$appRootPath = "D:\Apps\Root"
$appNames = if (Test-Path $appRootPath) {
    Get-ChildItem -Directory $appRootPath | Select-Object -ExpandProperty Name
} else {
    @("App1", "App2", "App3")  # Default apps if directory not found
}

# Create GUI Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "DevOps Web.config Encrypter"
$form.Size = New-Object System.Drawing.Size(400, 200)
$form.StartPosition = "CenterScreen"

# Label
$label = New-Object System.Windows.Forms.Label
$label.Text = "Select Application:"
$label.Size = New-Object System.Drawing.Size(300, 20)
$label.Location = New-Object System.Drawing.Point(20, 20)
$form.Controls.Add($label)

# Dropdown for Applications
$dropdown = New-Object System.Windows.Forms.ComboBox
$dropdown.Location = New-Object System.Drawing.Point(20, 50)
$dropdown.Size = New-Object System.Drawing.Size(300, 20)
$dropdown.Items.AddRange($appNames)
$dropdown.SelectedIndex = 0
$form.Controls.Add($dropdown)

# Encrypt Button
$encryptButton = New-Object System.Windows.Forms.Button
$encryptButton.Text = "Encrypt"
$encryptButton.Location = New-Object System.Drawing.Point(20, 90)
$encryptButton.Size = New-Object System.Drawing.Size(80, 30)
$form.Controls.Add($encryptButton)

# Decrypt Button
$decryptButton = New-Object System.Windows.Forms.Button
$decryptButton.Text = "Decrypt"
$decryptButton.Location = New-Object System.Drawing.Point(120, 90)
$decryptButton.Size = New-Object System.Drawing.Size(80, 30)
$form.Controls.Add($decryptButton)

# Close Button
$closeButton = New-Object System.Windows.Forms.Button
$closeButton.Text = "Close"
$closeButton.Location = New-Object System.Drawing.Point(220, 90)
$closeButton.Size = New-Object System.Drawing.Size(80, 30)
$form.Controls.Add($closeButton)

# Event Handlers
$encryptButton.Add_Click({
    $selectedApp = $dropdown.SelectedItem
    if ($selectedApp) {
        Start-Process -NoNewWindow -FilePath "powershell.exe" -ArgumentList "-noprofile -executionpolicy bypass -file `"$PSScriptRoot\DevOpsEncrypter.ps1`" -AppName `"$selectedApp`" -Encrypt"
        [System.Windows.Forms.MessageBox]::Show("Encryption initiated for $selectedApp", "Info")
    }
})

$decryptButton.Add_Click({
    $selectedApp = $dropdown.SelectedItem
    if ($selectedApp) {
        Start-Process -NoNewWindow -FilePath "powershell.exe" -ArgumentList "-noprofile -executionpolicy bypass -file `"$PSScriptRoot\DevOpsEncrypter.ps1`" -AppName `"$selectedApp`" -Decrypt"
        [System.Windows.Forms.MessageBox]::Show("Decryption initiated for $selectedApp", "Info")
    }
})

$closeButton.Add_Click({
    $form.Close()
})

# Run Form
[void]$form.ShowDialog()
