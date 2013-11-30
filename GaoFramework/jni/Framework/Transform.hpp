/**
 * @file Transform.hpp
 * @author Jheng Wei Ciao
 *
 * Transformation class.
 *
 */
#ifndef GAO_FRAMEWORK_TRANSFORM_H
#define GAO_FRAMEWORK_TRANSFORM_H

#include "DataType.hpp"
#include "Vector2D.hpp"
#include "GraphicsDefine.hpp"



namespace Gao
{
    namespace Framework
    {
        /**
         * @brief Transformation class.
         */
        class Transform
        {

        public:

            Transform();

            virtual ~Transform();
            
            //==========================================================
            // Translation
            //==========================================================

            inline virtual GaoVoid SetTranslate(GaoReal32 x, GaoReal32 y);

            inline virtual GaoVoid SetTranslate(Vector2D& coord);

            inline virtual GaoVoid ModifyTranslate(GaoReal32 x, GaoReal32 y);

            inline virtual GaoVoid ModifyTranslate(Vector2D& coord);

            inline virtual GaoReal32 GetTranslateX() const;

            inline virtual GaoReal32 GetTranslateY() const;

            //==========================================================
            // Rotation
            //==========================================================

            inline virtual GaoVoid SetRotateByRadian(GaoReal32 radian);

            inline virtual GaoVoid SetRotateByDegree(GaoUInt32 degree);

            inline virtual GaoVoid ModifyRotateByRadian(GaoReal32 radian);
            
            inline virtual GaoVoid ModifyRotateByDegree(GaoUInt32 degree);

            inline virtual GaoReal32 GetRotateByRadian() const;

            inline virtual GaoReal32 GetRotateByDegree() const;

            //==========================================================
            // Scale
            //==========================================================
            
            inline virtual GaoVoid SetScale(GaoReal32 scale);

            inline virtual GaoVoid ModifyScale(GaoReal32 scale);

            inline virtual GaoReal32 GetScale() const;

//            inline GaoBool IsRotatedOrScaled() const;
            


        private:

            GaoReal32      m_TranslateX;
            GaoReal32      m_TranslateY;
            GaoReal32      m_RotateAngle;  // Radian
            GaoReal32      m_Scale;

        };
    }
}

#include "Transform.inl"

#endif
