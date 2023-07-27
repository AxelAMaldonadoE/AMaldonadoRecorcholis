<?php
    require_once 'FunctionsDatabase.php';
    $db = new FunctionsDatabase();

    // Obtener datos del objeto json recibido
    $data = json_decode(file_get_contents('php://input'), true);
    $response = array("correct" => false);
    if ($data["Nombre"] != "") {
        $newNombre = $data["Nombre"];
        $dbResponse = $db->AddPais($newNombre);
        if ( $dbResponse["correct"] ) {
            $response["correct"] = true;
            $response["status_message"] = "Datos insertados correctamente.";
            http_response_code(201);
            echo json_encode($response);
        } else {
            $response["status_message"] = $dbResponse["status_message"];
            http_response_code(400);
            echo json_encode($response);
        }
    } else {
        http_response_code(400);
        $response["status_message"] = "No se recibieron datos";
        echo json_encode($response);
    }
?>
