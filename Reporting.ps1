function report{
          $PC=$InputBox.text;
          $date = Get-Date -Format "MMddyy-HHmm";
          invoke-command -ComputerName $PC -ScriptBlock {
          Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Sort-Object DisplayName | Export-CSV -NoTypeInformation -Path C:\"$Using:PC$Using:date".csv;
          }
          Copy-Item -Path \\"$PC"\c$\"$PC$date".csv -Destination C:\Reports\
          Remove-Item -Path \\"$PC"\c$\"$PC$date".csv
          If ( Test-Path -Path C:\Reports\"$PC$date".csv -PathType Leaf)
          {$outputBox.Text = "$PC$date.csv saved to c:\Reports\" | Out-String}
          Else
          {$outputBox.Text = "Error! Check your entry."}
          }

function ShowPrinters{
    $PC=$InputBox.text;
    $printers = get-printer -computername $PC | Select-Object Name, PortName | Sort-Object Name | Out-String;
    $OutputBox.Text = "$printers"
    }


    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")  

    $Form = New-Object System.Windows.Forms.Form
    $Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
    $Form.Text = "Pull Remote System Report"   
    $Form.Size = New-Object System.Drawing.Size(720,900)  
    $Form.StartPosition = "CenterScreen" #loads the window in the center of the screen
    $Form.BackgroundImageLayout = "Zoom"
    $Form.MinimizeBox = $False
    $Form.MaximizeBox = $False
    $Form.WindowState = "Normal"
    $Form.SizeGripStyle = "Hide"
    $Icon = [system.drawing.icon]::ExtractAssociatedIcon($PSHOME + "\powershell.exe")
    $Form.Icon = $Icon
    
    #### Title - Powershell GUI Tool ###################################################
    $Label = New-Object System.Windows.Forms.Label
    $LabelFont = New-Object System.Drawing.Font("Calibri",18,[System.Drawing.FontStyle]::Bold)
    $Label.Font = $LabelFont
    $Label.Text = "Enter PC name then click a button"
    $Label.AutoSize = $True
    $Label.Location = New-Object System.Drawing.Size(10,40) 
    $Form.Controls.Add($Label)
 
    #### Input window with "Computer name" label ##########################################
    $InputBox = New-Object System.Windows.Forms.TextBox 
    $InputBox.Location = New-Object System.Drawing.Size(375,50) 
    $InputBox.Size = New-Object System.Drawing.Size(180,20) 
    $Form.Controls.Add($InputBox)
    $Label2 = New-Object System.Windows.Forms.Label
    $Label2.Text = "Computer name:"
    $Label2.AutoSize = $True
    $Label2.Location = New-Object System.Drawing.Size(375,30) 
    $Form.Controls.Add($Label2)
 
    ##########BUTTONS##############
    $groupBox = New-Object System.Windows.Forms.GroupBox
    $groupBox.Location = New-Object System.Drawing.Size(10,95)
    $groupBox.size = New-Object System.Drawing.Size(685,100)
    $groupBox.text = "Functions:"
    $Form.Controls.Add($groupBox)

    #########Pull Report###########
    $report = New-Object System.Windows.Forms.Button
    $report.Location = New-Object System.Drawing.Size(15,20)
    $report.size = New-Object System.Drawing.Size(150,60)
    $report.text = "Pull Report"
    $report.Add_Click({report})
    $report.Cursor = [System.Windows.Forms.Cursors]::Hand
    $groupBox.Controls.Add($report)


    #### Show Printers #############
    $ShowPrinters = New-Object System.Windows.Forms.Button
    $ShowPrinters.Location = New-Object System.Drawing.Size(180,20)
    $ShowPrinters.Size = New-Object System.Drawing.Size(150,60)
    $ShowPrinters.Text = "Show Printers"
    $ShowPrinters.Add_Click({ShowPrinters})
    $ShowPrinters.Cursor = [System.Windows.Forms.Cursors]::Hand
    $groupBox.Controls.Add($ShowPrinters)

###################### END BUTTONS ######################################################
 
    #### Output Box Field ###############################################################
    $outputBox = New-Object System.Windows.Forms.RichTextBox
    $outputBox.Location = New-Object System.Drawing.Size(10,215) 
    $outputBox.Size = New-Object System.Drawing.Size(685,640)
    $outputBox.Font = New-Object System.Drawing.Font("Consolas", 12 ,[System.Drawing.FontStyle]::Regular)
    $outputBox.MultiLine = $True
    $outputBox.ScrollBars = "Vertical"
    $outputBox.Text = " `
    "
    $Form.Controls.Add($outputBox)
 
    ##############################################
 
    $Form.Add_Shown({$Form.Activate()})
    [void] $Form.ShowDialog()

