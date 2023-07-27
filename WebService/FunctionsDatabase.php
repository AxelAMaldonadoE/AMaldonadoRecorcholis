<?php
    class FunctionsDatabase {
        private $conn;
        
        // Constructor
        function __construct() {
            require_once 'DbConnect.php';
            
            // Conectando a la base de datos
            $db = new DbConnect();
            $this->conn = $db->connect();
        }
        
        /*
         Agregar un nuevo pais
         */
        public function AddPais($nombre) {
            mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
            $stmt = $this->conn->prepare("CALL AddPais(?);");
            $stmt->bind_param("s", $nombre);
            try {
                if ($stmt->execute()) {
                    $response = Array("correct" => true);
                    return $response;
                }
            } catch (Exception $e) {
                $response = Array("correct" => false);
                if ( $e->getCode() == 1062) {
                    $response["status_message"] = "Ya existe el nombre en la tabla!";
                } else {
                    $response["status_message"] = $e->getMessage();
                }
                return $response;
            }
        }
        
        /*
         Agregar un nuevo estado con el id del pais
         */
        public function AddEstado($newNombre, $idPais) {
            $stmt = $this->conn->prepare("CALL AddEstadoByPais(?, ?);");
            $stmt->bind_param("si", $newNombre, $idPais);
            try {
                if ($stmt->execute()) {
                    $response = Array("correct" => true);
                    return $response;
                }
            } catch (Exception $e) {
                $response = Array("correct" => false);
                if ( $e->getCode() == 1062) {
                    $response["status_message"] = "Ya existe el nombre en la tabla!";
                } else {
                    $response["status_message"] = $e->getMessage();
                }
                return $response;
            }
        }
        
        /*
         Actualizar el nombre del pais
         */
        public function UpdatePais($newNombre, $idPais) {
            $stmt = $this->conn->prepare("CALL UpdatePais(?, ?);");
            $stmt->bind_param("si", $newNombre, $idPais);
            try {
                if ($stmt->execute()) {
                    $result = mysqli_stmt_affected_rows($stmt);
                    if ($result > 0) {
                        $response = Array("correct" => true);
                        return $response;
                    } else {
                        $response = Array("correct" => false);
                        $response["status_message"] = "No se actualizo la información, verifica el nombre";
                        return $response;
                    }
                }
            } catch (Exception $e) {
                $response = Array("correct" => false);
                if ( $e->getCode() == 1062) {
                    $response["status_message"] = "Ya existe el nombre en la tabla!";
                } else {
                    $response["status_message"] = $e->getMessage();
                }
                return $response;
            }
        }
        
        /*
         Actualizar el nombre del estado
         */
        public function UpdateEstado($newNombre, $idEstado) {
            $stmt = $this->conn->prepare("CALL UpdateEstado(?, ?);");
            $stmt->bind_param("si", $newNombre, $idEstado);
            try {
                if ($stmt->execute()) {
                    $result = mysqli_stmt_affected_rows($stmt);
                    if ($result > 0) {
                        $response = Array("correct" => true);
                        return $response;
                    } else {
                        $response = Array("correct" => false);
                        $response["status_message"] = "No se actualizo la información, verifica el nombre";
                        return $response;
                    }
                }
            } catch (Exception $e) {
                $response = Array("correct" => false);
                if ( $e->getCode() == 1062) {
                    $response["status_message"] = "Ya existe el nombre en la tabla!";
                } else {
                    $response["status_message"] = $e->getMessage();
                }
                return $response;
            }
        }
        
        /*
         Eliminar el pais con los estados en cascada
         */
        public function DeletePais($idPais) {
            $stmt = $this->conn->prepare("CALL DeletePais(?);");
            $stmt->bind_param("i", $idPais);
            $stmt->execute();
            $result = mysqli_stmt_affected_rows($stmt);
            if ($result > 0) {
                return true;
            } else {
                return false;
            }
        }
        
        /*
         Eliminar un estado mediante su id
         */
        public function DeleteEstado($idEstado) {
            $stmt = $this->conn->prepare("CALL DeleteEstado(?);");
            $stmt->bind_param("i", $idEstado);
            $stmt->execute();
            $result = mysqli_stmt_affected_rows($stmt);
            if ($result > 0) {
                return true;
            } else {
                return false;
            }
        }
        
        /*
         Buscar en la tabla Paises
         */
        public function SearchPais($keyword) {
            $stmt = $this->conn->prepare("CALL SearchPais(?);");
            $stmt->bind_param("s", $keyword);
            $stmt->execute();
            $result = $stmt->get_result();
            $datos = [];
            if (mysqli_num_rows($result) > 0) {
                while ($row = $result->fetch_object()) {
                    $datos[] = $row;
                }
            }
            return $datos;
        }
        
        /*
         Buscar en la tabla de Estados
         */
        public function SearchEstado($keyword) {
            $stmt = $this->conn->prepare("CALL SearchEstado(?);");
            $stmt->bind_param("s", $keyword);
            $stmt->execute();
            $result = $stmt->get_result();
            $datos = [];
            if (mysqli_num_rows($result) > 0) {
                while ($row = $result->fetch_object()) {
                    $datos[] = $row;
                }
            }
            return $datos;
        }
    }

?>
