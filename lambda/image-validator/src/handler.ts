import { S3Event, S3Handler } from "aws-lambda";

const getExtension = (key: string): string => {
    const filename = key.split("/").pop() ?? key;
    const index = filename.lastIndexOf(".");
    if (index < 0) {
        return "";
    }
    return filename.slice(index + 1).toLowerCase();
};

export const handler: S3Handler = async (event: S3Event) => {
    for (const record of event.Records) {
        const bucketName = record.s3.bucket.name;
        const objectKey = decodeURIComponent(record.s3.object.key.replace(/\+/g, " "));
        const extension = getExtension(objectKey);

        if (!["webp", "png", "jpg", "jpeg", "gif", "svg"].includes(extension)) {
            console.warn("Unsupported image extension", {
                bucketName,
                objectKey,
                extension,
            });
            continue;
        }

        console.log("Image format accepted", {
            bucketName,
            objectKey,
            extension,
            size: record.s3.object.size,
        });
    }
};
