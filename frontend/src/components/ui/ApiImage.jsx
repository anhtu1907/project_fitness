import { useEffect, useState } from "react";
import { apiResource } from "../../services/baseApi";
import PlaceHolderImg from "../../assets/images/fall-back.png";
function ApiImage({ imageId, alt = "Image", className = "" }) {
  const [imageUrl, setImageUrl] = useState("");
  const [error, setError] = useState(false);

  useEffect(() => {
    let isMounted = true;
    setError(false);

    const fetchImage = async () => {
      try {
        const response = await apiResource(imageId);
        if (!isMounted) return;

        const blob = response.data;
        const objectUrl = URL.createObjectURL(blob);
        setImageUrl(objectUrl);
      } catch (err) {
        if (!isMounted) return;
        console.error(`Failed to load image ${imageId}:`, err);
        setError(true);
      }
    };

    if (imageId) {
      fetchImage();
    }

    return () => {
      isMounted = false;
      // Clean up the object URL to prevent memory leaks
      if (imageUrl) {
        URL.revokeObjectURL(imageUrl);
      }
    };
  }, [imageId]);

  if (error || !imageUrl) {
    return <img src={PlaceHolderImg} alt={alt} className={className} />;
  }

  return <img src={imageUrl} alt={alt} className={className} />;
}

export default ApiImage;
