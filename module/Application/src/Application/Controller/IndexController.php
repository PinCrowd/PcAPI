<?php
/**
 * Zend Framework (http://framework.zend.com/)
 *
 * @link      http://github.com/zendframework/ZendSkeletonApplication for the canonical source repository
 * @copyright Copyright (c) 2005-2012 Zend Technologies USA Inc. (http://www.zend.com)
 * @license   http://framework.zend.com/license/new-bsd New BSD License
 */

namespace Application\Controller;

use Zend\Mvc\Controller\AbstractActionController;
use Zend\View\Model\ViewModel;
use Zend\View\Model\JsonModel;

class IndexController extends AbstractActionController
{
    public function indexAction()
    {

        $model =  new JsonModel();
        if(($jsonp = $this->request->getQuery('jsonp')) || ($jsonp =  $this->request->getPost('jsonp'))){
            $model->setJsonpCallback($jsonp);
        }
        $model->date = date(DATE_ATOM);
        $model->string = 'test string';
        return $model;
    }
}
