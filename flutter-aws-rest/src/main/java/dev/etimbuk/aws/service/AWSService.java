package dev.etimbuk.aws.service;

import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;

@Service
public class AWSService {

    @Value("${aws.access.key}")
    private String accessKey;

    @Value("${aws.access.secret}")
    private String accessSecret;

    @Value("${aws.s3.default-bucket-name}")
    private String bucketName;

    @PostConstruct
    public void verifyBucketExists() {
        AmazonS3 s3Client = amazonS3Client();
        if (!s3Client.doesBucketExistV2(bucketName)) {
            s3Client.createBucket(bucketName);
        }
    }

    public AmazonS3 amazonS3Client() {
        return AmazonS3ClientBuilder
                .standard()
                .withCredentials(new AWSStaticCredentialsProvider(awsCredentials()))
                .withRegion(Regions.EU_WEST_2)
                .build();
    }

    private AWSCredentials awsCredentials() {
        return new BasicAWSCredentials(accessKey, accessSecret);
    }
}