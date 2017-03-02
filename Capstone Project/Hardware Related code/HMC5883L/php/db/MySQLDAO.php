
<?php


class MySQLDao {
var $dbhost = null;
var $dbuser = null;
var $dbpass = null;
var $conn = null;
var $dbname = null;
var $result = null;

public function openConnection() {
    
define('DB_HOST', getenv('OPENSHIFT_MYSQL_DB_HOST'));
define('DB_PORT', getenv('OPENSHIFT_MYSQL_DB_PORT'));
define('DB_USER', getenv('OPENSHIFT_MYSQL_DB_USERNAME'));
define('DB_PASS', getenv('OPENSHIFT_MYSQL_DB_PASSWORD'));
define('DB_NAME', getenv('OPENSHIFT_GEAR_NAME'));

$dbhost = constant("DB_HOST"); // Host name 
$dbuser = constant("DB_USER"); // Mysql username 
$dbpass = constant("DB_PASS"); // Mysql password 
$dbname = constant("DB_NAME"); // Database name 

$this->dbhost = $dbhost;
$this->dbuser = $dbuser;
$this->dbpass = $dbpass;
$this->dbname = $dbname;

  
$this->conn = new mysqli($this->dbhost, $this->dbuser, $this->dbpass, $this->dbname);


if (mysqli_connect_errno()) {
            throw new Exception("Could not establish connection with database");         
} 
       
$this->conn->set_charset("utf8");
        
}

public function closeConnection() {
if ($this->conn != null){
$this->conn->close();}

}

    public function testSelect() {
        $returnValue = array();
        $sql = "select * from test";
        $result = $this->conn->query($sql);
        if ($result != null && (mysqli_num_rows($result) > 0)) {
            $row = $result->fetch_array(MYSQLI_ASSOC);
            if (!empty($row)) {
                $returnValue = $row;
            }
        }
        return $returnValue;
    }
    
    public function testInsert() {
        $sql = "INSERT INTO test (foo, bar) VALUES (?, ?)";
        $statement = $this->conn->prepare($sql);
        if (!$statement)
            throw new Exception($this->conn->error);
        $statement->bind_param("ss", $param1, $param2);
        $param1 = 'test_foo';
        $param2 = 'test_bar';
        $returnValue = $statement->execute();
        return $returnValue;
    }
    
    public function testCreate() {
        $sql = "CREATE TABLE test (foo VARCHAR(20), bar VARCHAR(20))";
        $statement = $this->conn->query($sql);
        if (!$statement)
            throw new Exception($this->conn->error);
    }
    
    public function testDrop() {
        $sql = "DROP TABLE IF EXISTS test";
        $statement = $this->conn->query($sql);
        if (!$statement)
            throw new Exception($this->conn->error);
    }
    
public function getUserDetails($email)
{
$returnValue = array();
$sql = "select * from users where email='" . $email . "'";

$result = $this->conn->query($sql);
if ($result != null && (mysqli_num_rows($result) >= 1)) {
$row = $result->fetch_array(MYSQLI_ASSOC);
if (!empty($row)) {
$returnValue = $row;
}
}
return $returnValue;
}

public function registerUser($email, $first_name, $last_name, $password,$salt)
{
$sql = "INSERT INTO users (email, first_name,last_name, user_password,salt) VALUES (?,?,?,?,?)";
$statement = $this->conn->prepare($sql);

if (!$statement)
throw new Exception($statement->error);

$statement->bind_param("sssss", $email, $first_name, $last_name, $password,$salt);
$returnValue = $statement->execute();

return $returnValue;
}


public function storeXml($value)
{
 //performing sql query
$sql = "INSERT INTO test_xml (data) VALUES (?) ";
$statement = $this->conn->prepare($sql);

if(!$statement)
    throw new Exception($statement->error);

$statement->bind_param("i", $value);
$returnValue = $statement ->execute();

return $returnValue;
}

     public function storeEmailToken($user_id, $email_token)
    { 
        $sql = "INSERT INTO email_tokens （user_id, email_token) VALUES (?,?)";
        $statement = $this->conn->prepare($sql);
        if (!$statement)
            throw new Exception($statement->error);
        $statement->bind_param("is", $user_id, $email_token);
        $returnValue = $statement->execute();
        return $returnValue;  
    } 

    
        function getUserIdWithToken($emailToken)
    {
        $returnValue = array();
        $sql = "select user_id from email_tokens where email_token='" . $emailToken . "'";
  
        $result = $this->conn->query($sql);
        if ($result != null && (mysqli_num_rows($result) >= 1)) {
            $row = $result->fetch_array(MYSQLI_ASSOC);
            if (!empty($row)) {
                $returnValue = $row['user_id'];
            }
        }
        return $returnValue;  
        
    }
    
    function setEmailConfirmedStatus($status, $user_id)
    {
        $sql = "update users set isEmailConfirmed=? where user_id=?";
        $statement = $this->conn->prepare($sql);
        if (!$statement)
            throw new Exception($statement->error);
        $statement->bind_param("ii", $status, $user_id);
        $returnValue = $statement->execute();  
        
        return $returnValue;
        
    }
    
    
    function deleteUsedToken($emailToken)
    {
        $sql = "delete from email_tokens where email_token=?";
        $statement = $this->conn->prepare($sql);
        if (!$statement)
            throw new Exception($statement->error);
        $statement->bind_param("s", $emailToken);
        $returnValue = $statement->execute();  
        
        return $returnValue;
    }
    
    public function storePasswordToken($user_id, $token)
    {
        $sql = "Insert into password_tokens （user_id, password_token) VALUES (?,?)";
        $statement = $this->conn->prepare($sql);
        if (!$statement)
            throw new Exception($statement->error);
        $statement->bind_param("is", $user_id, $token);
        $returnValue = $statement->execute();
        
        return $returnValue;
        
    }  
 
    
    function getUserIdWithPasswordToken($token)
    {
        $returnValue = null;
        $sql = "select user_id from password_tokens where password_token='" . $token . "'";
  
        $result = $this->conn->query($sql);
        if ($result != null && (mysqli_num_rows($result) >= 1)) {
            $row = $result->fetch_array(MYSQLI_ASSOC);
            if (!empty($row)) {
                $returnValue = $row['user_id'];
            }
        }
        return $returnValue;  
    }
    
    function updateUserPassword($user_id,$secured_password,$salt)
    {
        $sql = "update users set user_password=?, salt=? where user_id=?";
        $statement = $this->conn->prepare($sql);
        if (!$statement)
            throw new Exception($statement->error);
        $statement->bind_param("ssi", $secured_password, $salt, $user_id);
        $returnValue = $statement->execute();
        
        return $returnValue;    
    }
    
    function deleteUsedPasswordToken($token)
    {
        $sql = "delete from password_tokens where password_token=?";
        $statement = $this->conn->prepare($sql);
        if (!$statement)
            throw new Exception($statement->error);
        $statement->bind_param("s", $token);
        $returnValue = $statement->execute();
        
        return $returnValue;  
    }

}
