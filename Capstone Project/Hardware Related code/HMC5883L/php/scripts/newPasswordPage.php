<?php
require("../db/MySQLDAO.php");
//require("../db/Conn.php");
/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

if(!empty($_POST["password_1"]) && !empty($_POST["password_2"]) && !empty($_POST["token"]))
{
    
    $password_1 = htmlentities($_POST["password_1"]);
    $password_2 = htmlentities($_POST["password_2"]); 
    $token = htmlentities($_POST["token"]);   
    
    if($password_1 == $password_2)
    {
        $dao = new MySQLDAO($dbhost, $dbuser, $dbpassword, $dbname);
        $dao->openConnection();
        
        $user_id = $dao->getUserIdWithPasswordToken($token);
        
        if(!empty($user_id))
        {
        // Generate secure password       
         $salt = openssl_random_pseudo_bytes(16);
         $secured_password = sha1($password_1 . $salt); 
         
         // Update user's passwords
        $result = $dao->updateUserPassword($user_id,$secured_password,$salt);
        
        if($result)
        {
            $dao->deleteUsedPasswordToken($token);  
            $userMessage = "Succesfully stored you new password";
            header("Location:passwordSuccussfullyReset.php?message=" . $userMessage);
            return;
        } else {
            
            $userMessage = "Could not update password at this time.";
        }
            
        } else {
            $userMessage="Could not retrieve user details with provided information";
        }
        
        
    } else {
        
        $userMessage="Passwords do not match";
    }
    
}
?>


<html>
    <head>
        <title>Create new password</title>
        
       <style>
            .password_field
            {
                margin:10px;
            }
            
            .button{
                margin:10px;
            }
        </style>     
    </head>
    <body>
        <h1>Create new password</h1>
        
       <?php 
        if(!empty($userMessage))
        {
            echo "<b>".$userMessage."</b>";
        }
       ?>
        
        <form method="POST" action="<?php $_SERVER["PHP_SELF"]?>">
        <div><input type="password" name="password_1" placeholder="New password:" class="password_field"/></div>
        <div><input type="password" name="password_2" placeholder="Repeat password:" class="password_field"/></div>
        <div><input type="submit" value="Save" class="button"/></div>
        
        <input type="hidden" value="<?php echo $_GET["token"];?>" name="token"/>
        
        </form>
        
    </body>
</html>