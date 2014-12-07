

<?php

error_reporting(E_ALL);
require_once('riak-php-client/src/Basho/Riak/Riak.php');
require_once('riak-php-client/src/Basho/Riak/Bucket.php');
require_once('riak-php-client/src/Basho/Riak/Exception.php');
require_once('riak-php-client/src/Basho/Riak/Link.php');
require_once('riak-php-client/src/Basho/Riak/MapReduce.php');
require_once('riak-php-client/src/Basho/Riak/Object.php');
require_once('riak-php-client/src/Basho/Riak/StringIO.php');
require_once('riak-php-client/src/Basho/Riak/Utils.php');
require_once('riak-php-client/src/Basho/Riak/Link/Phase.php');
require_once('riak-php-client/src/Basho/Riak/MapReduce/Phase.php');



# Connect to Riak
$client = new Basho\Riak\Riak('54.68.217.138', 8098);

# Choose a bucket name
$bucket = $client->bucket('mapgames1');
#$obj = $bucket->newBinary('30', 'day of defeat');
#$obj->store();
$obj = $bucket->getBinary('[2014,12,4]');
$data= $obj -> getData(); 

?>

<script type='text/javascript'>
   
        var myVariable = <?php echo(json_encode($data)); ?>;
    	document.write (myVariable);
</script>


