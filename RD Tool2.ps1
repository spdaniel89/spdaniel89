function EnableRD{
    $PC=$InputBox.text;
    If ( $PC -eq 'Exit' )
    {
    [Environment]::Exit(0)
    }
    ElseIf ( $PC -eq '' )
    {
    $OutputBox.text = "You must enter a PC name." | Out-String
    }
    Else
    {
    $OutputBox.text = "Enabled!" | Out-String
          invoke-command -ComputerName $PC -ScriptBlock {
            Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0
            Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
            Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "Us erAuthentication" -Value 1
        }        
    }

    
}

function ConnectRD{
    $PC=$InputBox.text;
    If ( $PC -eq 'Exit' )
    {
    [Environment]::Exit(0)
    }
    ElseIf ( $PC -eq '' )
    {
    $OutputBox.text = "You must enter a PC name." | Out-String
    }
    Else
    {
    $OutputBox.text = "Connecting..." | Out-String
    mstsc /v:$PC
    }
}

function DisableRD{
    $PC=$InputBox.text;
    If ( $PC -eq 'Exit' )
    {
    [Environment]::Exit(0)
    }
    ElseIf ( $PC -eq '' )
    {
    $OutputBox.text = "You must enter a PC name." | Out-String
    }
    Else
    {
    $OutputBox.text = "Disabled!" | Out-String
    invoke-command -ComputerName $PC -ScriptBlock{
        Disable-NetFirewallRule -DisplayGroup "Remote Desktop"
        Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 1
        }
        }
}

function DisableExit{
    $PC=$InputBox.text;
     $OutputBox.text = "Disabled, exiting!" | Out-String
    invoke-command -ComputerName $PC -ScriptBlock{
        Disable-NetFirewallRule -DisplayGroup "Remote Desktop"
        Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 1
        }
[Environment]::Exit(0)
}
    


###################### CREATING PS GUI TOOL #############################
 
    #### Form settings #################################################################
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")  
 
    $Form = New-Object System.Windows.Forms.Form
    $Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
    $Form.Text = "RD Enable and Connect"   
    $Form.Size = New-Object System.Drawing.Size(720,360)  
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
 
###################### BUTTONS ##########################################################
 
    #### Group boxes for buttons ########################################################
    $groupBox = New-Object System.Windows.Forms.GroupBox
    $groupBox.Location = New-Object System.Drawing.Size(10,95) 
    $groupBox.size = New-Object System.Drawing.Size(685,100)
    $groupBox.text = "Functions:"
    $Form.Controls.Add($groupBox) 
 
    #### Enable RD #################################################################
    $EnableRD = New-Object System.Windows.Forms.Button
    $EnableRD.Location = New-Object System.Drawing.Size(15,20)
    $EnableRD.Size = New-Object System.Drawing.Size(150,60)
    $EnableRD.Text = "EnableRD"
    $EnableRD.Add_Click({EnableRD})
    $EnableRD.Cursor = [System.Windows.Forms.Cursors]::Hand
    $groupBox.Controls.Add($EnableRD)
 
    #### Connect ###################################################################
    $ConnectRD = New-Object System.Windows.Forms.Button
    $ConnectRD.Location = New-Object System.Drawing.Size(180,20)
    $ConnectRD.Size = New-Object System.Drawing.Size(150,60)
    $ConnectRD.Text = "Connect Session"
    $ConnectRD.Add_Click({ConnectRD})
    $ConnectRD.Cursor = [System.Windows.Forms.Cursors]::Hand
    $groupBox.Controls.Add($ConnectRD)
 
    #### Disable RD ################################################################
    $DisableRD = New-Object System.Windows.Forms.Button
    $DisableRD.Location = New-Object System.Drawing.Size(345,20)
    $DisableRD.Size = New-Object System.Drawing.Size(150,60)
    $DisableRD.Text = "Disable RD"
    $DisableRD.Add_Click({DisableRD})
    $DisableRD.Cursor = [System.Windows.Forms.Cursors]::Hand
    $groupBox.Controls.Add($DisableRD)

    #### Disable RD and Exit########################################################
    $DisableExit = New-Object System.Windows.Forms.Button
    $DisableExit.Location = New-Object System.Drawing.Size(510,20)
    $DisableExit.Size = New-Object System.Drawing.Size(150,60)
    $DisableExit.Text = "Disable RD and Exit"
    $DisableExit.Add_Click({DisableExit})
    $DisableExit.Cursor = [System.Windows.Forms.Cursors]::Hand
    $groupBox.Controls.Add($DisableExit)
 
###################### END BUTTONS ######################################################
 
    #### Output Box Field ###############################################################
    $outputBox = New-Object System.Windows.Forms.RichTextBox
    $outputBox.Location = New-Object System.Drawing.Size(10,215) 
    $outputBox.Size = New-Object System.Drawing.Size(685,100)
    $outputBox.Font = New-Object System.Drawing.Font("Consolas", 12 ,[System.Drawing.FontStyle]::Regular)
    $outputBox.MultiLine = $True
    $outputBox.ScrollBars = "Vertical"
    $outputBox.Text = " `
    Status"
    $Form.Controls.Add($outputBox)
 
    ##############################################
 
    $Form.Add_Shown({$Form.Activate()})
    [void] $Form.ShowDialog()










