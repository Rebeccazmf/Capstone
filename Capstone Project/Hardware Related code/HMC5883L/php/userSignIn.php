<?php
require(dirname(__FILE__).'/db/MySQLDAO.php');
$dao =new MySQLDao();
    
    try{

$userEmail = htmlentities($_REQUEST["userEmail"]);
$userPassword = htmlentities($_REQUEST["userPassword"]);
$returnValue = array();

if(empty($userEmail) || empty($userPassword))
{
$returnValue["status"] = "error";
$returnValue["message"] = "Missing required field";
echo json_encode($returnValue);
return;
}

$dao->openConnection();
    }catch (Exception $e) {
        print('Caught exception: '.$e->getMessage()."\n");
    }
    
$userDetails =$dao->getUserDetails($userEmail);

if(empty($userDetails))
{
$returnValue["status"] = "error";
$returnValue["message"] = "User not found";
echo json_encode($returnValue);
return;
}

$userSecuredPassword=$userDetails["user_password"];
$userSalt = $userDetails["salt"];

if ($userSecuredPassword == sha1($userPassword.$userSalt))
{
    $returnValue["status"]= "200";
    $returnValue["userFirstName"] = $userDetails["first_name"];
    $returnValue["userLastName"] = $userDetails["last_name"];
    $returnValue["userEmail"] = $userDetails["email"];
    $returnValue["userId"] = $userDetails["user_id"];
}else{
    $returnValue["status"] = "error";
    $returnValue["message"] = "User not found";
    echo json_encode($returnValue);
}

$dao->closeConnection();
echo json_encode($returnValue);