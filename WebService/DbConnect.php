<?php
    class DbConnect{
        private $conn;
        
        // Funcion para conectar a la base de datos
        public function connect() {
            require_once 'Config.php';
            
            // Conectando a la base de datos MySQL
            $this->conn = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_DATABASE);
            
            // Retorna el database handler
            return $this->conn;
        }
    }
?>
