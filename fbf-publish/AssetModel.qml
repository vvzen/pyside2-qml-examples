import QtQuick 2.0


ListModel {

    id: assetModel

    ListElement {
        name: 'env_building_010'
        cbPublishAsset: true
        assetComponents:[

            ListElement {
                passName: 'position'
                path: '/mnt/vindaloo_projects/mbf2/02_seq/ep_02/mbf2_110_010/publish/mbf2_110_010_lighting/v002/p'
                cbPublishComponent: true
                startFrame: 1001
                endFrame: 1091
            },

            ListElement {
                passName: 'z'
                path: '/mnt/vindaloo_projects/mbf2/02_seq/ep_02/mbf2_110_010/publish/mbf2_110_010_lighting/v002/z'
                cbPublishComponent: true
                startFrame: 1001
                endFrame: 1091
            },

            ListElement {
                passName: 'crypto'
                path: '/mnt/vindaloo_projects/mbf2/02_seq/ep_02/mbf2_110_010/publish/mbf2_110_010_lighting/v002/crypto'
                cbPublishComponent: true
                startFrame: 1001
                endFrame: 1091
            },

            ListElement {
                passName: 'normals'
                path: '/mnt/vindaloo_projects/mbf2/02_seq/ep_02/mbf2_110_010/publish/mbf2_110_010_lighting/v002/normals'
                cbPublishComponent: true
                startFrame: 1001
                endFrame: 1091
            },

            ListElement {
                passName: 'id1'
                path: '/mnt/vindaloo_projects/mbf2/02_seq/ep_02/mbf2_110_010/publish/mbf2_110_010_lighting/v002/id1'
                cbPublishComponent: true
                startFrame: 1001
                endFrame: 1091
            }
        ]
    }

    ListElement {
        name: 'env_building_020'
        cbPublishAsset: true
        assetComponents: [

            ListElement {
                passName: 'position'
                path: '/mnt/vindaloo_projects/mbf2/02_seq/ep_02/mbf2_110_010/publish/mbf2_110_010_lighting/v001/p'
                cbPublishComponent: true
                startFrame: 1001
                endFrame: 1022
            },

            ListElement {
                passName: 'z'
                path: '/mnt/vindaloo_projects/mbf2/02_seq/ep_02/mbf2_110_010/publish/mbf2_110_010_lighting/v001/z'
                cbPublishComponent: true
                startFrame: 1001
                endFrame: 1015
            },

            ListElement {
                passName: 'crypto'
                path: '/mnt/vindaloo_projects/mbf2/02_seq/ep_02/mbf2_110_010/publish/mbf2_110_010_lighting/v007/crypto'
                cbPublishComponent: true
                startFrame: 1001
                endFrame: 1077
            }
        ]
    }

    ListElement {
        name: 'env_building_030'
        cbPublishAsset: true
    }

    ListElement {
        name: 'env_building_040'
        cbPublishAsset: true
    }

    ListElement {
        name: 'env_building_050'
        cbPublishAsset: true
    }

    ListElement {
        name: 'env_building_060'
        cbPublishAsset: true
    }
}
