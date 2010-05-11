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
		$staff_link = mysql_pconnect($staff_hostname.":".$staff_port, $staff_username, $staff_password);
		mysql_select_db($staff_database, $staff_link);
		
		$query = sprintf("select STAFF_ID, Name, LastName, Room, ipAddress from staff where STAFF_ID = '%s'",
		    mysql_real_escape_string($_REQUEST["id"], $staff_link));
		$staff_result = mysql_query($query, $staff_link);

		while($staff_row = mysql_fetch_assoc($staff_result))
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
				$room_link = mysql_pconnect($room_hostname.":".$room_port, $room_username, $room_password);
				mysql_select_db($room_database, $room_link);

				$query = sprintf("select Zipcode from room where Room='%s'",
				    mysql_real_escape_string($staff_row["Room"], $room_link));
				$room_result = mysql_query($query, $room_link);
				
				while($room_row = mysql_fetch_assoc($room_result))
				{
					?>
					<tr>
						<th>Zip code</th>
						<td><?php print($room_row["Zipcode"]); ?></td>
					</tr>
					<?php
					/* Query the associated street and city of the zipcode */
					$zipcode_link = mysql_pconnect($zipcode_hostname.":".$zipcode_port, $zipcode_username, $zipcode_password);
					mysql_select_db($zipcode_database, $zipcode_link);
					
					$query = sprintf("select Street, City from zipcode where Zipcode='%s'",
					    mysql_real_escape_string($room_row["Zipcode"], $zipcode_link));
					$zipcode_result = mysql_query($query, $zipcode_link);

					while($zipcode_row = mysql_fetch_assoc($zipcode_result))
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
