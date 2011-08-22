//
//  Shader.fsh
//  mobile
//
//  Created by Kyle Roche on 8/22/11.
//  Copyright (c) 2011 Isidorey. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
