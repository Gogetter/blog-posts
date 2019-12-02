package dev.etimbuk.aws.controllers;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.internal.BucketNameUtils;
import dev.etimbuk.aws.service.AWSService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@Slf4j
@RestController
@RequestMapping("/api/")
public class BucketController {

    private final AmazonS3 awsS3Client;

    public BucketController(AWSService awsService) {
        this.awsS3Client = awsService.amazonS3Client();
    }

    @GetMapping("buckets")
    public ResponseEntity listBuckets() {
        return ResponseEntity.ok(awsS3Client.listBuckets());
    }

    @PostMapping("buckets/{bucketName}")
    public ResponseEntity createBucket(@PathVariable String bucketName) {
//        BucketNameUtils.isValidV2BucketName()
        return ResponseEntity.ok("");
    }

    @PostMapping("buckets/{bucketName}/{folderName}")
    public ResponseEntity createFolder(@PathVariable String bucketName,
                                       @PathVariable String folderName) {
        return ResponseEntity.ok("");
    }

    @PostMapping("buckets/{bucketName}/{folderName}")
    public ResponseEntity uploadFileToS3(@PathVariable String bucketName,
                                         @PathVariable String folderName,
                                         @RequestParam("file") MultipartFile file) {
        return ResponseEntity.ok("");
    }

}