//
// Created by Кузяев Максим on 10.02.16.
// Copyright (c) 2016 zefender. All rights reserved.
//

import Foundation

struct FlickrPhotos {
    var perPage: Int
    var pages: Int
    var total: Int
    var page: Int
    var photos: [FlickrPhoto]?
}