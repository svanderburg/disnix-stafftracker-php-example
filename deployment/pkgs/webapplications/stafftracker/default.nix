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
    \$room_hostname = "${rooms.target.properties.hostname}";
    \$room_port = ${toString (rooms.target.container.mysqlPort)};
    \$room_database = "${rooms.name}";
    \$room_username = "${rooms.target.container.mysqlUsername}";
    \$room_password = "${rooms.target.container.mysqlPassword}";
    
    /* Staff database properties */
    \$staff_hostname = "${staff.target.properties.hostname}";
    \$staff_port = ${toString (staff.target.container.mysqlPort)};
    \$staff_database = "${staff.name}";
    \$staff_username = "${staff.target.container.mysqlUsername}";
    \$staff_password = "${staff.target.container.mysqlPassword}";
    
    /* Zipcode database properties */
    \$zipcode_hostname = "${zipcodes.target.properties.hostname}";
    \$zipcode_port = ${toString (zipcodes.target.container.mysqlPort)};
    \$zipcode_database = "${zipcodes.name}";
    \$zipcode_username = "${zipcodes.target.container.mysqlUsername}";
    \$zipcode_password = "${zipcodes.target.container.mysqlPassword}";
    ?>
    EOF
  '';
  
  installPhase = ''
    mkdir -p $out/webapps/stafftracker
    cp -av * $out/webapps/stafftracker
  '';
}
