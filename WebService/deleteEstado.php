<?php
    require_once 'FunctionsDatabase.php';
    $db = new FunctionsDatabase();

    // Obtener datos del objeto json recibido
    $response = array("correct" => false);
    if (isset($_GET['idEstado']) && $_GET['idEstado'] != "") {
        $idEstado = $_GET['idEstado'];
        if ( $db->DeleteEstado($idEstado) ) {
            $response["correct"] = true;
            $response["status_message"] = "Datos eliminados correctamente.";
            http_response_code(200);
            echo json_encode($response);
        } else {
            $response["status_message"] = "No fue posible eliminar los datos!!";
            http_response_code(404);
            echo json_encode($response);
        }
    } else {
        $response["status_message"] = "No se recibieron datos";
        http_response_code(400);
        echo json_encode($response);
    }
?>
