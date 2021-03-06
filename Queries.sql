CREATE TABLE MAP_LOCATIONS
(
LOCATIONNAME VARCHAR(50),
COORDINATES SDO_GEOMETRY
);

INSERT INTO MAP_LOCATIONS VALUES('MyHome', SDO_GEOMETRY(2001,NULL,SDO_POINT_TYPE(34.032073, -118.286648,NULL),NULL,NULL));
INSERT INTO MAP_LOCATIONS VALUES('Ralphs', SDO_GEOMETRY(2001,NULL,SDO_POINT_TYPE(34.031695, -118.290768,NULL),NULL,NULL));
INSERT INTO MAP_LOCATIONS VALUES('Manas', SDO_GEOMETRY(2001,NULL,SDO_POINT_TYPE(34.028836, -118.291801,NULL),NULL,NULL));
INSERT INTO MAP_LOCATIONS VALUES('TacoBell', SDO_GEOMETRY(2001,NULL,SDO_POINT_TYPE(34.022286, -118.291813,NULL),NULL,NULL));
INSERT INTO MAP_LOCATIONS VALUES('LeaveyLibrary', SDO_GEOMETRY(2001,NULL,SDO_POINT_TYPE(34.023076, -118.287046,NULL),NULL,NULL));
INSERT INTO MAP_LOCATIONS VALUES('LyonCenter', SDO_GEOMETRY(2001,NULL,SDO_POINT_TYPE(34.024391, -118.288248,NULL),NULL,NULL));
INSERT INTO MAP_LOCATIONS VALUES('OHE', SDO_GEOMETRY(2001,NULL,SDO_POINT_TYPE(34.020445, -118.289530,NULL),NULL,NULL));
INSERT INTO MAP_LOCATIONS VALUES('ArtofLiving', SDO_GEOMETRY(2001,NULL,SDO_POINT_TYPE(34.030728, -118.283082,NULL),NULL,NULL));
INSERT INTO MAP_LOCATIONS VALUES('Subway', SDO_GEOMETRY(2001,NULL,SDO_POINT_TYPE(34.022799, -118.279838,NULL),NULL,NULL));

INSERT INTO user_sdo_geom_metadata 
(TABLE_NAME,COLUMN_NAME,DIMINFO,SRID)
VALUES
('MAP_LOCATIONS','COORDINATES',SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X',-180,180,0.0000005),SDO_DIM_ELEMENT('Y',-180,180,0.0000005)),NULL);

CREATE INDEX SPINDEX ON MAP_LOCATIONS(COORDINATES) INDEXTYPE IS MDSYS.SPATIAL_INDEX;

--(Query for Convex hull)

SELECT SDO_AGGR_CONVEXHULL(SDOAGGRTYPE(COORDINATES,0.0000005)) FROM MAP_LOCATIONS;

--(Query for nearest neighbours)

SELECT /*+ INDEX(ML SPINDEX) */  
ML.LOCATIONNAME  FROM MAP_LOCATIONS ML  WHERE SDO_NN(ML.COORDINATES,SDO_GEOMETRY(2001, NULL, SDO_POINT_TYPE(34.032073,-118.286648,NULL), NULL,
  NULL),  'SDO_NUM_RES=4') = 'TRUE';