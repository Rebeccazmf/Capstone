<?php

 try {
                require_once 'db/ConnServer.php';
                
                $returnValue = array();
                if(empty($_REQUEST["userEmail"]) ||empty($_REQUEST['userPassword']))
               {
                $returnValue["status"] = "error";
                $returnValue["message"] = "Missing required field";
                echo json_encode($returnValue);
                return;
                }
                $userEmail = htmlentities($_REQUEST["userEmail"]);
                $userPassword = htmlentities($_REQUEST["userPassword"]);
                $userFirstName = htmlentities($_REQUEST["userFirstName"]);
                $userLastName = htmlentities($_REQUEST["userLastName"]);

                //Generate secure password
                $salt = openssl_random_pseudo_bytes(16);
                $secured_password = sha1($userPassword.$salt);
                $conn = mysqlConnector();
                
                $sql = "select * from users where email='" . $userEmail . "'";
                $stmt = $conn->prepare($sql);
                $stmt->execute();

                while($row = $stmt->fetch()) {
                        print_r($row);          
                }


        } catch(PDOException $e) {
                echo 'ERROR: ' . $e->getMessage();
        }
