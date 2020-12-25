import Data.Ratio


toDegrees :: Floating a => a -> a
toDegrees x = ((180 / pi) * x)

toRadians :: Floating a => a -> a
toRadians x = ((pi / 180) * x)

sind, cosd, tand, asind, acosd, atand :: Floating a => a -> a
sind =  sin . toRadians
cosd =  cos . toRadians
tand =  tan . toRadians
asind = toDegrees . asin
acosd = toDegrees . acos
atand = toDegrees . atan

atan2d :: RealFloat a => a -> a -> a
atan2d x y = toDegrees $ atan2 x y

-- use properFraction to convert ratio to mixed number
