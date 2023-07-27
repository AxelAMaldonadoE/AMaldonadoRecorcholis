<?php
    require_once 'FunctionsDatabase.php';
    $db = new FunctionsDatabase();
    if (isset($_GET["keyword"]) && $_GET["keyword"] != "") {
        $keyword = "%".$_GET["keyword"]."%";
        $datos["paises"] = $db->SearchPais($keyword);
        $datos["estados"] = $db->SearchEstado($keyword);
        http_response_code(200);
    } else {
        $datos = Array("correct" => false);
        $datos["status_message"] = "No se recibio ninguna palabra clave!";
        http_response_code(400);
    }
    echo json_encode($datos);
?>
