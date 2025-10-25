<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

// Test route for CI/CD pipeline
Route::get('/test-cicd', function () {
    return response()->json([
        'message' => 'CI/CD Pipeline is working!',
        'timestamp' => now(),
        'version' => '1.0.0',
    ]);
});

// Auto-deployment webhook endpoint
Route::post('/deploy', function () {
    // Simple webhook endpoint for auto-deployment
    // In production, you'd want to add authentication and validation
    
    $output = [];
    $returnCode = 0;
    
    // Execute the auto-deployment script
    exec('/var/www/html/scripts/auto-deploy.sh 2>&1', $output, $returnCode);
    
    return response()->json([
        'status' => $returnCode === 0 ? 'success' : 'error',
        'message' => $returnCode === 0 ? 'Deployment completed successfully' : 'Deployment failed',
        'output' => $output,
        'timestamp' => now(),
    ]);
});