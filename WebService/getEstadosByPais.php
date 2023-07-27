<?php
    require_once 'Config.php';
    $conn = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_DATABASE);
    $jsonObject = json_decode(file_get_contents('php://input'), true);
    if ($jsonObject["IdPais"] != 0 && $jsonObject["IdPais"] != "") {
        $idPais = $jsonObject["IdPais"];
        $queryStr = "CALL GetEstadosByPais(". $idPais .");";
        $result = mysqli_query($conn, $queryStr);
        if (mysqli_num_rows($result) > 0) {
            while ($row = $result->fetch_object()) {
                $array = json_decode(json_encode($row), true);
                $array["IdEstado"] = (int) $array["IdEstado"];
                $datos["results"][] = $array;
            }
            http_response_code(200);
        } else {
            $datos = Array("correct" => false);
            $datos["status_message"] = "No se encontraron datos del pais";
            http_response_code(404);
        }
        mysqli_close($conn);
        echo json_encode($datos);
    } else {
        $datos = Array("correct" => false);
        $datos["status_message"] = "No se recibio información correcta!";
        http_response_code(400);
        echo json_encode($datos);
    }

?>
