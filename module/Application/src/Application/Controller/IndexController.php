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

/**
 * @property $request \Zend\Http\Request
 */
class IndexController extends AbstractActionController
{
    public function indexAction()
    {

        /* @var \Zend\Http\Request $request */
        $request = $this->request;
        $header = $request->getHeader('Accept')->getFieldValue();
        if (strstr($header, 'application/json')
            || strstr($header, 'application/javascript')
        ) {
            $model = new JsonModel();
            if (($jsonp = $request->getQuery('jsonp'))
                || ($jsonp = $request->getPost('jsonp'))
            ) {
                $model->setJsonpCallback($jsonp);
            }
        } else {
            $model = new ViewModel();
        }
        $model->date = date(DATE_ATOM);
        $model->string = 'test string';
        $model->accept = $request->getHeader('Accept')->toString();
        return $model;
    }
}
