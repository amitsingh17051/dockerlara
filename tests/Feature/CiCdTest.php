<?php

namespace Tests\Feature;

use Tests\TestCase;

class CiCdTest extends TestCase
{
    /**
     * Test that CI/CD pipeline is working.
     *
     * @return void
     */
    public function test_cicd_endpoint_returns_success()
    {
        $response = $this->get('/test-cicd');

        $response->assertStatus(200);
        $response->assertJson([
            'message' => 'CI/CD Pipeline is working!',
            'version' => '1.0.0',
        ]);
        $response->assertJsonStructure([
            'message',
            'timestamp',
            'version',
        ]);
    }

    /**
     * Test that the application is running.
     *
     * @return void
     */
    public function test_application_is_running()
    {
        $response = $this->get('/');

        $response->assertStatus(200);
    }
}
