<?php
namespace App\OCP;

use App\OCP\Contracts\Remunerable;

class PayCheck
{
    protected $balance;

    /**
     * 
     */
    public function calculate(Remunerable $worker)
    {
        $this->balance = $worker->remuneration();
    }
}