import { GetObjectCommand, PutObjectCommand, S3Client } from "@aws-sdk/client-s3";
import { S3Handler } from "aws-lambda";
import sharp from "sharp";

const s3 = new S3Client({});

const handler: S3Handler = async (event) => {
    const record = event.Records[0];
    const bucketName = record.s3.bucket.name;
    const objectKey = decodeURIComponent(record.s3.object.key.replace(/\+/g, " "));
    const isNotWebp = !objectKey.toLowerCase().endsWith(".webp");
    const incorrectFormatMessage = `The uploaded image ${objectKey} is not in WebP format.`;
    const processingFormatMessage = `Processing the uploaded image ${objectKey} in bucket ${bucketName}.`;

    if (isNotWebp) {
        console.log(incorrectFormatMessage);
        return;
    }

    console.log(processingFormatMessage);

    const response = await s3.send(
        new GetObjectCommand({
            Bucket: bucketName,
            Key: objectKey,
        })
    );

    const bodyResponse = await response?.Body?.transformToByteArray();
    if (!bodyResponse) throw new Error("Error: No body response from S3");

    // Convert image to jpeg format
    const convertedToJpeg = await sharp(Buffer.from(bodyResponse)).jpeg().toBuffer();

    // Upload the converted image to s3.
    const outputKey = objectKey.replace(/\.webp$/i, ".jpg");
    await s3.send(
        new PutObjectCommand({
            Bucket: bucketName,
            Key: outputKey,
            Body: convertedToJpeg,
            ContentType: "image/jpeg",
        })
    );
};

export default handler;