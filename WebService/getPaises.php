<?php
    require_once 'Config.php';
    $conn = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_DATABASE);
    $queryStr = "CALL GetPaises()";
    $result = mysqli_query($conn, $queryStr);
    $datos["results"] = [];
    if (mysqli_num_rows($result) > 0) {
        while ($row = $result->fetch_object()) {
            $array = json_decode(json_encode($row), true);
            $array["IdPais"] = (int) $array["IdPais"];
            $datos["results"][] = $array;
        }
//        $datos["status_message"] = "Done";
//        $datos["correct"] = true;
        http_response_code(200);
    } else {
        $datos = Array("correct" => false);
        $datos["status_message"] = "No se encontro la información!!";
        http_response_code(404);
    }
    mysqli_close($conn);
    echo json_encode($datos);
?>
