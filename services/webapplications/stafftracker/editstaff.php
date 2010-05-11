<?php
require_once("config.inc.php");
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Edit staff</title>
		<link rel="stylesheet" type="text/css" href="style.css">
	</head>
	<body>
		<form action="modifystaff.php" method="post">
			<p>
				<input type="hidden" name="action" value="<?php print($_REQUEST["id"] == "" ? "insert" : "update"); ?>">
				<?php
				if($_REQUEST["id"] != "")
				{
					?>
					<input type="hidden" name="old_Id" value="<?php print($_REQUEST["id"]); ?>">
					<?php
				}
				?>				
			</p>
			<?php
			if($_REQUEST["id"] == "")
			{
				$staff_row = NULL;
			}
			else
			{
				$staff_link = mysql_pconnect($staff_hostname.":".$staff_port, $staff_username, $staff_password);				
				mysql_select_db($staff_database, $staff_link);
				
				$query = sprintf("select STAFF_ID, Name, LastName, Room, ipAddress from staff where STAFF_ID='%s'",
				    mysql_real_escape_string($_REQUEST["id"], $staff_link));
				$staff_result = mysql_query($query, $staff_link);
				
				$staff_row = mysql_fetch_asoc($staff_result);
			}
			?>
			<table>
				<tr>
					<th>Id</th>
					<td><input type="text" name="Id" value="<?php print($staff_row == NULL ? "" : $staff_row["STAFF_ID"]); ?>"></td>
				</tr>
				<tr>
					<th>Name</th>
					<td><input type="text" name="Name" value="<?php print($staff_row == NULL ? "" : $staff_row["Name"]); ?>"></td>
				</tr>
				<tr>
					<th>Last name</th>
					<td><input type="text" name="LastName" value="<?php print($staff_row == NULL ? "" : $staff_row["LastName"]); ?>"></td>
				</tr>
				<tr>
					<th>Room</th>
					<td>
						<select name="Room">
							<?php
							$room_link = mysql_pconnect($room_hostname.":".$room_port, $room_username, $room_password);
							mysql_select_db($room_database, $room_link);
							
							$query = "select Room from room order by Room";
							$room_result = mysql_query($query, $room_link);
							
							while($room_row = mysql_fetch_assoc($room_result))
							{
								?>
								<option value="<?php print($room_row["Room"]); ?>"<?php if($staff_row["Room"] == $room_row["Room"]) print(" selected"); ?>><?php print($room_row["Room"]); ?></option>
								<?php
							}
							?>
						</select>
					</td>
				</tr>
				<tr>
					<th>IP address</th>
					<td><input type="text" name="ipAddress" value="<?php print($staff_row == NULL ? "" : $staff_row["ipAddress"]); ?>"></td>
				</tr>	
				<tr>
					<td><input type="submit" value="Submit"></td>
					<td><input type="reset" value="Reset"></td>
				</tr>
			</table>
		</form>
	</body>
</html>
