
<?php
if(empty($_REQUEST["userEmail"]) ||empty($_REQUEST['userPassword']))
{
$returnValue["status"] = "error";
$returnValue["message"] = "Missing required field";
echo json_encode($returnValue);
return;
}

