<?php
/**
 * File containing the eZFS2ClusterStaleCacheTest class.
 *
 * @copyright Copyright (C) 1999-2010 eZ Systems AS. All rights reserved.
 * @license http://ez.no/licenses/gnu_gpl GNU GPL v2
 * @version //autogentag//
 * @package tests
 */

/**
 * This test applies to the stalecache features for the eZFS2 cluster handler
 * @package tests
 * @group cluster
 * @group eZFS2
 */
class eZFS2ClusterStaleCacheTest extends eZClusterStaleCacheTest
{
    protected $clusterClass = 'eZFS2FileHandler';

    /**
     * Test setup
     *
     * Load an instance of file.ini
     **/
    public function setUp()
    {
        parent::setUp();

        // We need to clear the existing handler if it was loaded before the INI
        // settings changes
        if ( isset( $GLOBALS['eZClusterFileHandler_chosen_handler'] ) and
            !$GLOBALS['eZClusterFileHandler_chosen_handler'] instanceof $this->clusterClass )
            unset( $GLOBALS['eZClusterFileHandler_chosen_handler'] );

        // Load database parameters for cluster
        // The same DSN than the relational database is used
        $fileINI = eZINI::instance( 'file.ini' );
        $this->previousFileHandler = $fileINI->variable( 'ClusteringSettings', 'FileHandler' );
        $fileINI->setVariable( 'ClusteringSettings', 'FileHandler', $this->clusterClass );
    }

    public function tearDown()
    {
        // restore the previous file handler
        if ( $this->previousFileHandler !== null )
        {
            $fileINI = eZINI::instance( 'file.ini' );
            $fileINI->setVariable( 'ClusteringSettings', 'FileHandler', $this->previousFileHandler );
            $this->previousFileHandler = null;
            if ( isset( $GLOBALS['eZClusterFileHandler_chosen_handler'] ) )
                unset( $GLOBALS['eZClusterFileHandler_chosen_handler'] );
        }

        parent::tearDown();
    }
}
?>