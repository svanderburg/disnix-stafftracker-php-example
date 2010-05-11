<?php
require_once("config.inc.php"); 
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Staff table</title>
		<link rel="stylesheet" type="text/css" href="style.css">
	</head>
	<body>
		<p><a href="editstaff.php">Add staff</a></p>
		
		<table>
			<tr>
				<th>Id</th>
				<th>Name</th>
				<th>Last name</th>
				<th>Room</th>
				<th>IP address</th>
			</tr>
			<?php
			$link = mysql_pconnect($staff_hostname.":".$staff_port, $staff_username, $staff_password);
			mysql_select_db($staff_database, $link);
			
			$query = "select STAFF_ID, Name, LastName, Room, ipAddress from staff order by STAFF_ID";
			$result = mysql_query($query, $link);
			
			if(!$result)
			{
				?>
				<tr><td colspan="7">Error: cannot connect to the staff database!</td></tr>
				<?php
			}
			else
			{
				while($row = mysql_fetch_assoc($result))
				{
					?>
					<tr>
						<td><a href="displaystaff.php?id=<?php print($row["STAFF_ID"]); ?>"><?php print($row["STAFF_ID"]); ?></a></td>
						<td><?php print($row["Name"]); ?></td>
						<td><?php print($row["LastName"]); ?></td>
						<td><?php print($row["Room"]); ?></td>
						<td><?php print($row["ipAddress"]); ?></td>
						<td><a href="editstaff.php?id=<?php print($row["STAFF_ID"]); ?>"></a></td>
						<td><a href="modifystaff.php?action=delete&amp;id=<?php print($row["STAFF_ID"]); ?>"></a></td>
					</tr>
					<?php			
				}
			}
			?>
		</table>
	</body>
</html>
