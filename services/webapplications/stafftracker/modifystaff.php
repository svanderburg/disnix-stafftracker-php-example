<?php
require_once("config.inc.php");

switch($_REQUEST["action"])
{
	case "insert":
		$link = mysql_pconnect($staff_hostname.":".$staff_port, $staff_username, $staff_password);
		mysql_select_db($staff_database, $link);
		
		$query = sprintf("insert into staff values ('%s', '%s', '%s', '%s', '%s')",
		    mysql_real_escape_string($_REQUEST["Id"], $link),
		    mysql_real_escape_string($_REQUEST["Name"], $link),
		    mysql_real_escape_string($_REQUEST["LastName"], $link),
		    mysql_real_escape_string($_REQUEST["Room"], $link),
		    mysql_real_escape_string($_REQUEST["ipAddress"], $link));
		
		mysql_query($query, $link);
		break;
	case "update":
		$link = mysql_pconnect($staff_hostname.":".$staff_port, $staff_username, $staff_password);
		mysql_select_db($staff_database, $link);
		
		$query = sprintf("update staff set ".
		    "STAFF_ID = '%s', ".
		    "Name = '%s', ".
		    "LastName = '%s', ".
		    "Room = '%s', ".
		    "ipAddress = '%s' ".
		    "where STAFF_ID = '%s'",
		    mysql_real_escape_string($_REQUEST["Id"], $link),
		    mysql_real_escape_string($_REQUEST["Name"], $link),
		    mysql_real_escape_string($_REQUEST["LastName"], $link),
		    mysql_real_escape_string($_REQUEST["Room"], $link),
		    mysql_real_escape_string($_REQUEST["ipAddress"], $link),
		    mysql_real_escape_string($_REQUEST["old_Id"], $link));
		
		mysql_query($query, $link);
		break;
	case "delete":
		$link = mysql_pconnect($staff_hostname.":".$staff_port, $staff_username, $staff_password);
		mysql_select_db($staff_database, $link);
		
		$query = sprintf("delete from staff where STAFF_ID = '%s'", mysql_real_escape_string($_REQUEST["Id"], $link));
		
		mysql_query($query, $link);
		break;
}

header("Location: index.php");
?>
