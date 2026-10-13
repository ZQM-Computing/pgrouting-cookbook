-- Example 12: Export route geometry as GeoJSON

-- Get route as geometry
WITH route AS (
    SELECT * FROM pgr_dijkstra(
        'SELECT id, source, target, cost, reverse_cost FROM ways',
        1, 4, false
    )
),
route_geom AS (
    SELECT
        r.seq,
        r.node,
        r.edge,
        r.cost,
        r.agg_cost,
        w.geom
    FROM route r
    JOIN ways w ON r.edge = w.id
    WHERE r.edge > 0
    ORDER BY r.seq
)
SELECT
    json_build_object(
        'type', 'FeatureCollection',
        'features', json_agg(
            json_build_object(
                'type', 'Feature',
                'geometry', ST_AsGeoJSON(geom)::json,
                'properties', json_build_object(
                    'seq', seq,
                    'node', node,
                    'edge', edge,
                    'cost', cost,
                    'agg_cost', agg_cost
                )
            )
        )
    ) AS geojson
FROM route_geom;

-- Export route summary
SELECT
    COUNT(*) as num_edges,
    SUM(cost) as total_cost,
    ST_Length(ST_Collect(geom)::geography) as total_distance_m
FROM route_geom;
