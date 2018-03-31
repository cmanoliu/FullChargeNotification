$APP_ID = 'PowerShell'
$notificationTitle = "The battery is fully charged"
$notificationText = "You might want to unplug the charger."

[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
$notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($APP_ID)
		
$capacityWmi = get-WmiObject -query "Select * from batteryfullchargedcapacity" -namespace 'root\wmi'
while (1) 
{ 
	$statusWmi =  get-WmiObject -query "select * from batterystatus" -namespace 'root\wmi'

	if ($statusWmi.PowerOnline -eq $True -and $statusWmi.RemainingCapacity -eq $capacityWmi.FullChargedCapacity) 
	{
		$template = @"
<toast>
	<visual>
		<binding template="ToastText02">
			<text id="1">$($notificationTitle)</text>
			<text id="2">$($notificationText)</text>
		</binding>
	</visual>
</toast>
"@

		$xml = New-Object Windows.Data.Xml.Dom.XmlDocument
		$xml.LoadXml($template)

		$toast = New-Object Windows.UI.Notifications.ToastNotification $xml
		$toast.ExpirationTime = [DateTimeOffset]::Now.AddMinutes(1)
		$notifier.Show($toast);
	}
    sleep 60
}