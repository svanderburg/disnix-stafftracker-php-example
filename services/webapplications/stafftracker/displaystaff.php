<?php
require_once("config.inc.php");
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Display staff</title>
		<link rel="stylesheet" type="text/css" href="style.css">
	</head>
	<body>
		<?php
		/* Query the staff member */
		$staff_dbh = new PDO("mysql:host=".$staff_hostname.";port=".$staff_port.";dbname=".$staff_database, $staff_username, $staff_password, array(
			PDO::ATTR_PERSISTENT => true
		));
		
		$staff_stmt = $staff_dbh->prepare("select STAFF_ID, Name, LastName, Room, ipAddress from staff where STAFF_ID = ?");
		$staff_stmt->execute(array($_REQUEST["id"]));
		
		while($staff_row = $staff_stmt->fetch())
		{
			?>
			<table>
				<tr>
					<th>Id</th>
					<td><?php print($staff_row["STAFF_ID"]); ?></td>
				</tr>
				<tr>
					<th>Name</th>
					<td><?php print($staff_row["Name"]); ?></td>
				</tr>
				<tr>
					<th>Last name</th>
					<td><?php print($staff_row["LastName"]); ?></td>
				</tr>
				<tr>
					<th>Room</th>
					<td><?php print($staff_row["Room"]); ?></td>
				</tr>
				<?php
				/* Query the associated zipcode of the room */
				$room_dbh = new PDO("mysql:host=".$room_hostname.";port=".$room_port.";dbname=".$room_database, $room_username, $room_password, array(
					PDO::ATTR_PERSISTENT => true
				));

				$room_stmt = $room_dbh->prepare("select Zipcode from room where Room = ?");
				$room_stmt->execute(array($staff_row["Room"]));
				
				while($room_row = $room_stmt->fetch())
				{
					?>
					<tr>
						<th>Zip code</th>
						<td><?php print($room_row["Zipcode"]); ?></td>
					</tr>
					<?php
					/* Query the associated street and city of the zipcode */
					$zipcode_dbh = new PDO("mysql:host=".$zipcode_hostname.";port=".$zipcode_port.";dbname=".$zipcode_database, $zipcode_username, $zipcode_password, array(
						PDO::ATTR_PERSISTENT => true
					));
					
					$zipcode_stmt = $zipcode_dbh->prepare("select Street, City from zipcode where Zipcode = ?");
					$zipcode_stmt->execute(array($room_row["Zipcode"]));
					
					while($zipcode_row = $zipcode_stmt->fetch())
					{
						?>
						<tr>
							<th>Street</th>
							<td><?php print($zipcode_row["Street"]); ?></td>
						</tr>
						<tr>
							<th>City</th>
							<td><?php print($zipcode_row["City"]); ?></td>
						</tr>
						<?php
					}
				}
				?>
				<tr>
					<th>IP address</th>
					<td><?php print($staff_row["ipAddress"]); ?></td>
				</tr>
			</table>
			<?php
		}
		?>
	</body>
</html>
