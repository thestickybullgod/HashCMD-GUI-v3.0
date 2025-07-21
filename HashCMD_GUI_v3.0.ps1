Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$entryAssembly = [System.Reflection.Assembly]::GetEntryAssembly()
$exePath = if ($entryAssembly -ne $null) {
    [System.IO.Path]::GetDirectoryName($entryAssembly.Location)
} else {
    $PSScriptRoot
}

function Update-OutputFont {
    $script:fontOutput = New-Object System.Drawing.Font("Consolas", $numericFontSize.Value, [System.Drawing.FontStyle]::Bold)
    $script:fontVerdict = New-Object System.Drawing.Font("Consolas", ($numericFontSize.Value + 2), [System.Drawing.FontStyle]::Bold)

    $textBoxResult.Font = $script:fontOutput
    $textBoxLogViewer.Font = $script:fontOutput
}

# Create form
$form = New-Object System.Windows.Forms.Form
$form.Text = "HashCMD GUI"
$form.ClientSize = New-Object System.Drawing.Size(500, 640)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(240,240,240)
$form.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$fontOutput = New-Object System.Drawing.Font("Consolas", 14, [System.Drawing.FontStyle]::Bold)
$fontVerdict = New-Object System.Drawing.Font("Consolas", 14, [System.Drawing.FontStyle]::Bold)
$fontTimestamp = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
$labelHeader = New-Object System.Windows.Forms.Label
$labelHeader.Text = "HashCMD GUI"
$labelHeader.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$labelHeader.Location = New-Object System.Drawing.Point(20, 0)
$labelHeader.Size = New-Object System.Drawing.Size(440, 30)
$labelHeader.TextAlign = "MiddleCenter"
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false

$exePath = $null
$entryAssembly = [System.Reflection.Assembly]::GetEntryAssembly()

if ($entryAssembly -ne $null) {
    $exePath = [System.IO.Path]::GetDirectoryName($entryAssembly.Location)
} else {
    $exePath = $PSScriptRoot
}

$logPath = Join-Path $exePath "HashCMD_GUI_Log.txt"

# Tab control
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Location = New-Object System.Drawing.Point(10, 10)
$tabControl.Size = New-Object System.Drawing.Size(480, 600)
$form.Controls.Add($tabControl)
$tabMain = New-Object System.Windows.Forms.TabPage
$tabMain.Text = "Main"

$tabAbout = New-Object System.Windows.Forms.TabPage
$tabAbout.Text = "About"

$tabLogViewer = New-Object System.Windows.Forms.TabPage
$tabLogViewer.Text = "Log Viewer"

$tabSettings = New-Object System.Windows.Forms.TabPage
$tabSettings.Text = "Settings"

$checkAutoCopy = New-Object System.Windows.Forms.CheckBox
$checkAutoCopy.Text = "Auto-copy generated hash"
$checkAutoCopy.Location = New-Object System.Drawing.Point(20, 20)
$checkAutoCopy.Size = New-Object System.Drawing.Size(300, 20)

$comboDefaultMode = New-Object System.Windows.Forms.ComboBox
$comboDefaultMode.Location = New-Object System.Drawing.Point(20, 60)
$comboDefaultMode.Size = New-Object System.Drawing.Size(150, 20)
$comboDefaultMode.Items.AddRange(@("String Mode", "File Mode"))
$comboDefaultMode.SelectedIndex = 0

$labelFontSize = New-Object System.Windows.Forms.Label
$labelFontSize.Text = "Output font size:"
$labelFontSize.Location = New-Object System.Drawing.Point(20, 100)
$labelFontSize.Size = New-Object System.Drawing.Size(150, 20)

$numericFontSize = New-Object System.Windows.Forms.NumericUpDown
$numericFontSize.Location = New-Object System.Drawing.Point(180, 100)
$numericFontSize.Size = New-Object System.Drawing.Size(60, 20)
$numericFontSize.Minimum = 8
$numericFontSize.Maximum = 24
$numericFontSize.Value = 14

$tabSettings.Add_Enter({
    # Sync Mode Selection
    if ($comboDefaultMode.SelectedItem -eq "File Mode") {
        $radioFile.Checked = $true
    } else {
        $radioString.Checked = $true
    }

    # Sync Font Size
    $fontOutput = New-Object System.Drawing.Font("Consolas", $numericFontSize.Value, [System.Drawing.FontStyle]::Bold)
	Update-OutputFont
})

# Placeholders

$labelAbout = New-Object System.Windows.Forms.Label
$labelAbout.Text = @"
HashCMD_GUI v2.0
Crafted by Dustin W. Deen  
In collaborative ritual with Microsoft Copilot

A ritualistic hashing interface that turns cryptographic operations
into symbolic scrolls of clarity.

Features:
• String/File mode selection
• HMAC key support
• Timestamp footer with ritual seal
• Log Viewer and symbolic formatting

GitHub: https://github.com/thestickybullgod/HashCMD_GUI_v2.0
"@
$labelAbout.Location = New-Object System.Drawing.Point(20, 20)
$labelAbout.Size = New-Object System.Drawing.Size(440, 280)
$labelAbout.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$labelAbout.TextAlign = "TopLeft"
$labelAbout.AutoSize = $false
$labelAbout.BackColor = [System.Drawing.Color]::Transparent

$tabAbout.Controls.Add($labelAbout)

$textBoxLogViewer = New-Object System.Windows.Forms.TextBox
$textBoxLogViewer.Location = New-Object System.Drawing.Point(20, 20)
$textBoxLogViewer.Size = New-Object System.Drawing.Size(440, 500)
$textBoxLogViewer.Multiline = $true
$textBoxLogViewer.ReadOnly = $true
$textBoxLogViewer.ScrollBars = "Both"
$textBoxLogViewer.WordWrap = $false
$textBoxLogViewer.Font = $fontOutput

$tabLogViewer.Controls.Add($textBoxLogViewer)

# Mode toggle with font fix
$radioFont = New-Object System.Drawing.Font("Segoe UI", 9)

$radioString = New-Object System.Windows.Forms.RadioButton
$radioString.Text = "String Mode"
$radioString.Location = New-Object System.Drawing.Point(20, 40)
$radioString.Checked = $true
$radioString.Font = $radioFont
$radioString.AutoSize = $true


$radioFile = New-Object System.Windows.Forms.RadioButton
$radioFile.Text = "File Mode"
$radioFile.Location = New-Object System.Drawing.Point(150, 40)
$radioFile.Font = $radioFont
$radioFile.AutoSize = $true

# Input label
$labelInput = New-Object System.Windows.Forms.Label
$labelInput.Text = "Enter string:"
$labelInput.Location = New-Object System.Drawing.Point(20, 60)
$labelInput.Size = New-Object System.Drawing.Size(150, 20)

# Input textbox
$textBoxInput = New-Object System.Windows.Forms.TextBox
$textBoxInput.Location = New-Object System.Drawing.Point(20, 85)
$textBoxInput.Size = New-Object System.Drawing.Size(440, 20)

# File picker button
$buttonBrowse = New-Object System.Windows.Forms.Button
$buttonBrowse.Text = "Browse..."
$buttonBrowse.Location = New-Object System.Drawing.Point(380, 110)
$buttonBrowse.Size = New-Object System.Drawing.Size(80, 25)
$buttonBrowse.Visible = $false
$buttonBrowse.BackColor = [System.Drawing.Color]::FromArgb(0,122,204)
$buttonBrowse.ForeColor = [System.Drawing.Color]::White

# Algorithm dropdown
$comboAlgo = New-Object System.Windows.Forms.ComboBox
$comboAlgo.Location = New-Object System.Drawing.Point(20, 120)
$comboAlgo.Size = New-Object System.Drawing.Size(150, 20)
$comboAlgo.Items.AddRange(@("SHA256", "SHA1", "SHA512", "MD5", "SHA384", "RIPEMD160", "HMACSHA256", "HMACSHA512"))
$comboAlgo.SelectedIndex = 0

$comboAlgo.Add_SelectedIndexChanged({
    $selected = $comboAlgo.SelectedItem

	if ($selected -like "HMAC*") {
		$labelKey.Visible = $true
		$textBoxKey.Visible = $true
		$labelKey.Enabled = $true
		$textBoxKey.Enabled = $true
		$textBoxKey.BackColor = [System.Drawing.Color]::White
		$textBoxKey.ForeColor = [System.Drawing.Color]::Black
		$textBoxKey.TabStop = $true
	} else {
		$labelKey.Visible = $true   # Still shown, just disabled
		$textBoxKey.Visible = $true
		$labelKey.Enabled = $false
		$textBoxKey.Enabled = $false
		$textBoxKey.BackColor = [System.Drawing.Color]::LightGray
		$textBoxKey.ForeColor = [System.Drawing.Color]::DarkGray
		$textBoxKey.TabStop = $false
	}
})

# Hash comparison label
$labelCompare = New-Object System.Windows.Forms.Label
$labelCompare.Text = "Compare with hash:"
$labelCompare.Location = New-Object System.Drawing.Point(20, 150)
$labelCompare.Size = New-Object System.Drawing.Size(150, 20)

# Hash comparison textbox
$textBoxCompare = New-Object System.Windows.Forms.TextBox
$textBoxCompare.Location = New-Object System.Drawing.Point(20, 175)
$textBoxCompare.Size = New-Object System.Drawing.Size(440, 20)

# HMAC Key label
$labelKey = New-Object System.Windows.Forms.Label
$labelKey.Text = "HMAC Key:"
$labelKey.Location = New-Object System.Drawing.Point(20, 230)
$labelKey.Size = New-Object System.Drawing.Size(150, 20)

# HMAC Key textbox (masked)
$textBoxKey = New-Object System.Windows.Forms.TextBox
$textBoxKey.Location = New-Object System.Drawing.Point(20, 255)
$textBoxKey.Size = New-Object System.Drawing.Size(440, 20)
$textBoxKey.UseSystemPasswordChar = $true

# Initially hidden
$labelKey.Visible = $false
$textBoxKey.Visible = $false

# Log-to-file checkbox
$checkLog = New-Object System.Windows.Forms.CheckBox
$checkLog.Text = "Log to file"
$checkLog.Location = New-Object System.Drawing.Point(20, 205)

# Generate button
$buttonGenerate = New-Object System.Windows.Forms.Button
$buttonGenerate.Text = "Generate Hash"
$buttonGenerate.Location = New-Object System.Drawing.Point(20, 285)
$buttonGenerate.Size = New-Object System.Drawing.Size(150, 30)
$buttonGenerate.BackColor = [System.Drawing.Color]::FromArgb(0,122,204)
$buttonGenerate.ForeColor = [System.Drawing.Color]::White

# Compare button
$buttonCompare = New-Object System.Windows.Forms.Button
$buttonCompare.Text = "Compare Hash"
$buttonCompare.Location = New-Object System.Drawing.Point(190, 285)
$buttonCompare.Size = New-Object System.Drawing.Size(150, 30)
$buttonCompare.BackColor = [System.Drawing.Color]::FromArgb(0,122,204)
$buttonCompare.ForeColor = [System.Drawing.Color]::White

# Copy Output button
$buttonCopy = New-Object System.Windows.Forms.Button
$buttonCopy.Text = "Copy Output"
$buttonCopy.Location = New-Object System.Drawing.Point(360, 285)
$buttonCopy.Size = New-Object System.Drawing.Size(100, 30)
$buttonCopy.BackColor = [System.Drawing.Color]::FromArgb(0,122,204)
$buttonCopy.ForeColor = [System.Drawing.Color]::White

# View Log button
$buttonViewLog = New-Object System.Windows.Forms.Button
$buttonViewLog.Text = "View Log"
$buttonViewLog.Location = New-Object System.Drawing.Point(20, 320)
$buttonViewLog.Size = New-Object System.Drawing.Size(100, 30)
$buttonViewLog.BackColor = [System.Drawing.Color]::FromArgb(0,122,204)
$buttonViewLog.ForeColor = [System.Drawing.Color]::White

# Clear Output button
$buttonClear = New-Object System.Windows.Forms.Button
$buttonClear.Text = "Clear"
$buttonClear.Location = New-Object System.Drawing.Point(130, 320)  # ← to the right of View Log
$buttonClear.Size = New-Object System.Drawing.Size(100, 30)
$buttonClear.BackColor = [System.Drawing.Color]::FromArgb(0,122,204)
$buttonClear.ForeColor = [System.Drawing.Color]::White

# Clear log button
$buttonClearLog = New-Object System.Windows.Forms.Button
$buttonClearLog.Text = "Clear Log File"
$buttonClearLog.Location = New-Object System.Drawing.Point(20, 140)
$buttonClearLog.Size = New-Object System.Drawing.Size(120, 30)
$buttonClearLog.BackColor = [System.Drawing.Color]::FromArgb(220, 53, 69)  # subtle warning red
$buttonClearLog.ForeColor = [System.Drawing.Color]::White

$buttonClearLog.Add_Click({
    $confirm = [System.Windows.Forms.MessageBox]::Show(
        "Are you sure you want to clear the log file?", 
        "Confirm Clear", 
        [System.Windows.Forms.MessageBoxButtons]::YesNo, 
        [System.Windows.Forms.MessageBoxIcon]::Warning
    )

    if ($confirm -eq [System.Windows.Forms.DialogResult]::Yes) {
        $logPath = Join-Path $exePath "HashCMD_GUI_Log.txt"
        if (Test-Path $logPath) {
			Add-Content -Path $logPath -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') | Log cleared by user"
            Clear-Content -Path $logPath
            [System.Windows.Forms.MessageBox]::Show("Log file cleared.", "Success", "OK", "Information")
        } else {
            [System.Windows.Forms.MessageBox]::Show("No log file found.", "Error", "OK", "Error")
        }
    }
})

$buttonClear.Add_Click({
    $textBoxResult.Clear()
    $labelFooter.Text = ""  # Optional: reset timestamp
})

$buttonViewLog.Add_Click({
$logPath = Join-Path $exePath "HashCMD_GUI_Log.txt"

    if (Test-Path $logPath) {
        Start-Process "notepad.exe" $logPath
    } else {
        [System.Windows.Forms.MessageBox]::Show("No log file found.", "View Log", "OK", "Information")
    }
})

# Copy logic
$buttonCopy.Add_Click({
    if (![string]::IsNullOrWhiteSpace($script:generatedHash)) {
        [System.Windows.Forms.Clipboard]::SetText($script:generatedHash)
    } else {
        [System.Windows.Forms.MessageBox]::Show("No hash to copy.", "Clipboard", "OK", "Information")
    }
})

# Result Label/Output box
$textBoxResult = New-Object System.Windows.Forms.TextBox
$textBoxResult.Location = New-Object System.Drawing.Point(20, 350)
$textBoxResult.Size = New-Object System.Drawing.Size(440, 180)
$textBoxResult.Multiline = $true
$textBoxResult.ReadOnly = $true
$textBoxResult.BackColor = [System.Drawing.Color]::White
$textBoxResult.Font = $fontOutput
$textBoxResult.ScrollBars = "Vertical"
$textBoxResult.WordWrap = $true

# Mode toggle logic
$radioString.Add_CheckedChanged({
    $labelInput.Text = "Enter string:"
    $textBoxInput.Text = ""
    $buttonBrowse.Visible = $false
})

$radioFile.Add_CheckedChanged({
    $labelInput.Text = "Select file path:"
    $textBoxInput.Text = ""
    $buttonBrowse.Visible = $true
})

# File picker logic
$buttonBrowse.Add_Click({
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    if ($dialog.ShowDialog() -eq "OK") {
        $textBoxInput.Text = $dialog.FileName
    }
})

# Footer label
$labelFooter = New-Object System.Windows.Forms.Label
$labelFooter.Text = "Timestamp: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"  # Initial placeholder
$labelFooter.Location = New-Object System.Drawing.Point(20, 540)                # ← Within tab height
$labelFooter.Size = New-Object System.Drawing.Size(440, 20)
$labelFooter.TextAlign = "MiddleRight"
$labelFooter.ForeColor = [System.Drawing.Color]::DarkSlateGray
$labelFooter.Font = $fontTimestamp
$tabMain.Controls.Add($labelFooter)
$tabControl.TabPages.AddRange(@($tabMain, $tabAbout, $tabLogViewer, $tabSettings))

# Log Viewer Handler

$tabLogViewer.Add_Enter({
    $exePath = $null
    $entryAssembly = [System.Reflection.Assembly]::GetEntryAssembly()

    if ($entryAssembly -ne $null) {
        $exePath = [System.IO.Path]::GetDirectoryName($entryAssembly.Location)
    } else {
        $exePath = $PSScriptRoot
    }

    $logPath = Join-Path $exePath "HashCMD_GUI_Log.txt"

    if (Test-Path $logPath) {
        $textBoxLogViewer.Text = Get-Content $logPath -Raw
    } else {
        $textBoxLogViewer.Text = "No log entries found."
    }
	
	$fontOutput = New-Object System.Drawing.Font("Consolas", $numericFontSize.Value, [System.Drawing.FontStyle]::Bold)
	$textBoxLogViewer.Font = $fontOutput
})

# Leave Event from Settings Tab

$tabSettings.Add_Leave({
    if ($comboDefaultMode.SelectedItem -eq "File Mode") {
        $radioFile.Checked = $true
    } else {
        $radioString.Checked = $true
    }
})

$tabMain.Add_Enter({
    $fontOutput = New-Object System.Drawing.Font("Consolas", $numericFontSize.Value, [System.Drawing.FontStyle]::Bold)
    Update-OutputFont
})

# Generate hash logic
$buttonGenerate.Add_Click({
    $input = $textBoxInput.Text.Trim()

    if ([string]::IsNullOrWhiteSpace($input)) {
        [System.Windows.Forms.MessageBox]::Show("Please enter input before generating hash.", "Missing Input", "OK", "Warning")
        return
    }

    $algoName = $comboAlgo.SelectedItem
    $hash = ""
    try {
        switch ($algoName) {
            "SHA256" { $algo = [System.Security.Cryptography.SHA256]::Create() }
            "SHA1"   { $algo = [System.Security.Cryptography.SHA1]::Create() }
            "SHA512" { $algo = [System.Security.Cryptography.SHA512]::Create() }
            "MD5"    { $algo = [System.Security.Cryptography.MD5]::Create() }
            "SHA384" { $algo = [System.Security.Cryptography.SHA384]::Create() }
			"RIPEMD160" { $algo = [System.Security.Cryptography.RIPEMD160]::Create() }
			"HMACSHA256" {
    $key = [System.Text.Encoding]::UTF8.GetBytes($textBoxKey.Text)
    $algo = [System.Security.Cryptography.HMACSHA256]::new($key)
}
"HMACSHA512" {
    $key = [System.Text.Encoding]::UTF8.GetBytes($textBoxKey.Text)
    $algo = [System.Security.Cryptography.HMACSHA512]::new($key)
}
            default  { throw "Unsupported algorithm: $algoName" }
        }

        if ($radioString.Checked) {
            $bytes = [System.Text.Encoding]::UTF8.GetBytes($input)
        } elseif ($radioFile.Checked) {
            if (-not (Test-Path $input)) {
                throw "File not found: $input"
            }
            $bytes = [System.IO.File]::ReadAllBytes($input)
        } else {
            throw "No mode selected"
        }

        $hashBytes = $algo.ComputeHash($bytes)
        $hash = ($hashBytes | ForEach-Object { $_.ToString("x2") }) -join ''
        $textBoxResult.Text = $hash
		if ($checkAutoCopy.Checked) {
    [System.Windows.Forms.Clipboard]::SetText($hash)
}
		$textBoxResult.TextAlign = "Center"
		$textBoxResult.BackColor = [System.Drawing.Color]::White
		$fontOutput = New-Object System.Drawing.Font("Consolas", $numericFontSize.Value, [System.Drawing.FontStyle]::Bold)
		$textBoxResult.Font = $fontOutput
		$textBoxResult.SelectionStart = $textBoxResult.Text.Length
		$textBoxResult.ScrollToCaret()

		$labelFooter.Text = "Timestamp: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
		$labelFooter.ForeColor = [System.Drawing.Color]::DarkSlateGray
		$labelFooter.BackColor = [System.Drawing.Color]::FromArgb(240,240,240)
		$labelFooter.TextAlign = "MiddleRight"

        # Store hash for comparison
        $script:generatedHash = $hash

		# Log to file
		if ($checkLog.Checked) {
			$logPath = Join-Path $exePath "HashCMD_GUI_Log.txt"
			$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
			$mode = if ($radioString.Checked) { "String" } else { "File" }
			Add-Content -Path $logPath -Value "$timestamp | Mode: $mode | Input: $input | Algo: $algoName | Hash: $hash"
		}

    } catch {
        $textBoxResult.Text = "Error: $($_.Exception.Message)"
        $textBoxResult.BackColor = [System.Drawing.Color]::LightYellow
		$textBoxResult.SelectionStart = $textBoxResult.Text.Length
		$textBoxResult.ScrollToCaret()
    }
})

# Compare Hash logic
$buttonCompare.Add_Click({
    $compareHash = $textBoxCompare.Text.Trim()

    # Refresh fonts based on Settings
    Update-OutputFont

    # Refresh timestamp footer
    $labelFooter.Text = "Timestamp: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    $labelFooter.ForeColor = [System.Drawing.Color]::DarkSlateGray
    $labelFooter.BackColor = [System.Drawing.Color]::FromArgb(240,240,240)
    $labelFooter.TextAlign = "MiddleRight"

    if (-not $script:generatedHash) {
        $textBoxResult.Text = "No hash generated yet."
        $textBoxResult.BackColor = [System.Drawing.Color]::LightYellow
		$textBoxResult.Font = $script:fontOutput
        $textBoxResult.TextAlign = "Center"
        $textBoxResult.SelectionStart = $textBoxResult.Text.Length
        $textBoxResult.ScrollToCaret()
        return
    }

if (-not $compareHash) {
    $textBoxResult.Font = $fontOutput  # ← this now comes fresh from Update-OutputFont
    $textBoxResult.Text = "$script:generatedHash`r`n`r`nNo comparison hash provided."
    $textBoxResult.BackColor = [System.Drawing.Color]::LightYellow
    $textBoxResult.TextAlign = "Center"
    $textBoxResult.SelectionStart = $textBoxResult.Text.Length
    $textBoxResult.ScrollToCaret()
    return
}

    if ($script:generatedHash -eq $compareHash) {
        $textBoxResult.Font = $script:fontVerdict
        $textBoxResult.BackColor = [System.Drawing.Color]::LightGreen
        $textBoxResult.Text = "$script:generatedHash`r`n`r`n✅ MATCH"
    } else {
        $textBoxResult.Font = $script:fontVerdict
        $textBoxResult.BackColor = [System.Drawing.Color]::LightCoral
        $textBoxResult.Text = "$script:generatedHash`r`n`r`n❌ MISMATCH"
    }

    $textBoxResult.TextAlign = "Center"
    $textBoxResult.SelectionStart = $textBoxResult.Text.Length
    $textBoxResult.ScrollToCaret()
})

# TabMain Controls
$tabMain.Controls.Add($labelHeader)
$tabMain.Controls.Add($radioString)
$tabMain.Controls.Add($radioFile)
$tabMain.Controls.Add($labelInput)
$tabMain.Controls.Add($textBoxInput)
$tabMain.Controls.Add($buttonBrowse)
$tabMain.Controls.Add($comboAlgo)
$tabMain.Controls.Add($labelCompare)
$tabMain.Controls.Add($textBoxCompare)
$tabMain.Controls.Add($labelKey)
$tabMain.Controls.Add($textBoxKey)
$tabMain.Controls.Add($checkLog)
$tabMain.Controls.Add($buttonGenerate)
$tabMain.Controls.Add($buttonCompare)
$tabMain.Controls.Add($buttonCopy)
$tabMain.Controls.Add($buttonViewLog)
$tabMain.Controls.Add($buttonClear)
$tabMain.Controls.Add($textBoxResult)
$tabMain.Controls.Add($labelFooter)

$tabSettings.Controls.Add($checkAutoCopy)
$tabSettings.Controls.Add($comboDefaultMode)
$tabSettings.Controls.Add($labelFontSize)
$tabSettings.Controls.Add($numericFontSize)
$tabSettings.Controls.Add($buttonClearLog)

# Run form
$form.Topmost = $true
$form.Add_Shown({
    $form.Activate()
	
	$comboAlgo_Selected = $comboAlgo.SelectedItem
	if ($comboAlgo_Selected -like "HMAC*") {
		$labelKey.Visible = $true
		$textBoxKey.Visible = $true
		$labelKey.Enabled = $true
		$textBoxKey.Enabled = $true
		$textBoxKey.BackColor = [System.Drawing.Color]::White
		$textBoxKey.ForeColor = [System.Drawing.Color]::Black
		$textBoxKey.TabStop = $true
	} else {
		$labelKey.Visible = $true
		$textBoxKey.Visible = $true
		$labelKey.Enabled = $false
		$textBoxKey.Enabled = $false
		$textBoxKey.BackColor = [System.Drawing.Color]::LightGray
		$textBoxKey.ForeColor = [System.Drawing.Color]::DarkGray
		$textBoxKey.TabStop = $false
	}
    # Apply selected mode on launch
    if ($comboDefaultMode.SelectedItem -eq "File Mode") {
        $radioFile.Checked = $true
    } else {
        $radioString.Checked = $true
    }

    # Apply selected font size on launch
    $fontOutput = New-Object System.Drawing.Font("Consolas", $numericFontSize.Value, [System.Drawing.FontStyle]::Bold)
    Update-OutputFont
})
[void]$form.ShowDialog()