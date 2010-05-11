{stdenv}:
{rooms, staff, zipcodes}:

stdenv.mkDerivation {
  name = "stafftracker";
  src = ../../../../services/webapplications/stafftracker;
  
  # Generate config file
  buildPhase = ''
    cat > config.inc.php <<EOF
    <?php
    /* Room database properties */
    \$room_hostname = "${rooms.target.hostname}";
    \$room_port = ${toString (rooms.target.mysqlPort)};
    \$room_database = "${rooms.name}";
    \$room_username = "${rooms.target.mysqlUsername}";
    \$room_password = "${rooms.target.mysqlPassword}";
    
    /* Staff database properties */
    \$staff_hostname = "${staff.target.hostname}";
    \$staff_port = ${toString (staff.target.mysqlPort)};
    \$staff_database = "${staff.name}";
    \$staff_username = "${staff.target.mysqlUsername}";
    \$staff_password = "${staff.target.mysqlPassword}";
    
    /* Zipcode database properties */
    \$zipcode_hostname = "${zipcodes.target.hostname}";
    \$zipcode_port = ${toString (zipcodes.target.mysqlPort)};
    \$zipcode_database = "${zipcodes.name}";
    \$zipcode_username = "${zipcodes.target.mysqlUsername}";
    \$zipcode_password = "${zipcodes.target.mysqlPassword}";
    ?>
    EOF
  '';
  
  installPhase = ''
    ensureDir $out/webapps/stafftracker
    cp -av * $out/webapps/stafftracker
  '';
}
