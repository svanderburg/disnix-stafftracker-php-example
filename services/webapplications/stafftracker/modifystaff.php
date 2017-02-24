<?php
require_once("config.inc.php");

$dbh = new PDO("mysql:host=".$staff_hostname.";port=".$staff_port.";dbname=".$staff_database, $staff_username, $staff_password, array(
	PDO::ATTR_PERSISTENT => true
));

switch($_REQUEST["action"])
{
	case "insert":
		$stmt = $dbh->prepare("insert into staff values (?, ?, ?, ?, ?)");
		$stmt->execute(array($_REQUEST["Id"], $_REQUEST["Name"], $_REQUEST["LastName"], $_REQUEST["Room"], $_REQUEST["ipAddress"]));
		break;
	case "update":
		$stmt = $dbh->prepare("update staff set ".
		    "STAFF_ID = ?, ".
		    "Name = ?, ".
		    "LastName = ?, ".
		    "Room = ?, ".
		    "ipAddress = ? ".
		    "where STAFF_ID = ?");
		$stmt->execute(array($_REQUEST["Id"], $_REQUEST["Name"], $_REQUEST["LastName"], $_REQUEST["Room"], $_REQUEST["ipAddress"], $_REQUEST["old_Id"]));
		break;
	case "delete":
		$stmt = $dbh->prepare("delete from staff where STAFF_ID = ?");
		$stmt->execute(array($_REQUEST["id"]));
		break;
}

header("Location: index.php");
?>
