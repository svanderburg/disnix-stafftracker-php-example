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
			$dbh = new PDO("mysql:host=".$staff_hostname.";port=".$staff_port.";dbname=".$staff_database, $staff_username, $staff_password, array(
				PDO::ATTR_PERSISTENT => true
			));
			
			$stmt = $dbh->prepare("select STAFF_ID, Name, LastName, Room, ipAddress from staff order by STAFF_ID");
			
			if(!$stmt->execute())
			{
				?>
				<tr><td colspan="7">Error: cannot connect to the staff database!</td></tr>
				<?php
			}
			else
			{
				while($row = $stmt->fetch())
				{
					?>
					<tr>
						<td><a href="displaystaff.php?id=<?php print($row["STAFF_ID"]); ?>"><?php print($row["STAFF_ID"]); ?></a></td>
						<td><?php print($row["Name"]); ?></td>
						<td><?php print($row["LastName"]); ?></td>
						<td><?php print($row["Room"]); ?></td>
						<td><?php print($row["ipAddress"]); ?></td>
						<td><a href="editstaff.php?id=<?php print($row["STAFF_ID"]); ?>">Edit</a></td>
						<td><a href="modifystaff.php?action=delete&amp;id=<?php print($row["STAFF_ID"]); ?>">Delete</a></td>
					</tr>
					<?php
				}
			}
			?>
		</table>
	</body>
</html>
