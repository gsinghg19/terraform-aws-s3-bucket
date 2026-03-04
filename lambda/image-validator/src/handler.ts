import { GetObjectCommand, PutObjectCommand, S3Client } from "@aws-sdk/client-s3";
import { S3Event, S3Handler } from "aws-lambda";
import sharp from "sharp";

const s3 = new S3Client({});

interface S3ObjectInfo {
    bucketName: string;
    objectKey: string;
};

const getS3ObjectInfo = (event: S3Event): S3ObjectInfo => {
    const record = event.Records[0];
    const bucketName = record.s3.bucket.name;
    const objectKey = decodeURIComponent(record.s3.object.key.replace(/\+/g, " "));

    return { bucketName, objectKey };
}

const isWebp = (objectKey: string): boolean => {
    const mimeTypeIdentifier = objectKey.toLowerCase().endsWith(".webp");
    return mimeTypeIdentifier;
}

const getOutputJpegKey = (objectKey: string): string => {
    const outputKey = objectKey.replace(/\.webp$/i, ".jpg");
    return outputKey
}

const getObjectBytes = async (bucketName: string, objectKey: string): Promise<Uint8Array> => {
    const response = await s3.send(
        new GetObjectCommand({
            Bucket: bucketName,
            Key: objectKey,
        })
    );

    const bodyResponse = await response.Body?.transformToByteArray();
    if (!bodyResponse) throw new Error("Error: No body response from S3");

    return bodyResponse;
}

const convertToJpeg = async (bodyBytes: Uint8Array): Promise<Buffer> => {
    const jpegBuffer = await sharp(Buffer.from(bodyBytes)).jpeg().toBuffer();
    return jpegBuffer;
}

const uploadJpeg = async (bucketName: string, outputKey: string, imageBuffer: Buffer): Promise<void> => {
    await s3.send(
        new PutObjectCommand({
            Bucket: bucketName,
            Key: outputKey,
            Body: imageBuffer,
            ContentType: "image/jpeg",
        })
    );
}

const handler: S3Handler = async (event) => {
    const { bucketName, objectKey } = getS3ObjectInfo(event);
    const isNotWebp = !isWebp(objectKey);
    const incorrectFormatMessage = `The uploaded image ${objectKey} is not in WebP format.`;
    const processingFormatMessage = `Processing the uploaded image ${objectKey} in bucket ${bucketName}.`;

    if (isNotWebp) {
        console.log(incorrectFormatMessage);
        return;
    }

    console.log(processingFormatMessage);

    const bodyBytes = await getObjectBytes(bucketName, objectKey);
    const convertedToJpeg = await convertToJpeg(bodyBytes);
    const outputKey = getOutputJpegKey(objectKey);
    await uploadJpeg(bucketName, outputKey, convertedToJpeg);
};

export default handler;