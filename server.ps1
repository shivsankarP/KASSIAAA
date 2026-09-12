param (
    [int]$Port = 8000
)

$root = $PSScriptRoot
if (-not $root) { $root = Get-Location }

$mimeTypes = @{
    ".html"  = "text/html; charset=utf-8"
    ".htm"   = "text/html; charset=utf-8"
    ".css"   = "text/css; charset=utf-8"
    ".js"    = "application/javascript; charset=utf-8"
    ".mjs"   = "application/javascript; charset=utf-8"
    ".json"  = "application/json; charset=utf-8"
    ".png"   = "image/png"
    ".jpg"   = "image/jpeg"
    ".jpeg"  = "image/jpeg"
    ".webp"  = "image/webp"
    ".gif"   = "image/gif"
    ".svg"   = "image/svg+xml"
    ".ico"   = "image/x-icon"
    ".woff"  = "font/woff"
    ".woff2" = "font/woff2"
    ".ttf"   = "font/ttf"
    ".otf"   = "font/otf"
    ".mp4"   = "video/mp4"
    ".webm"  = "video/webm"
    ".mp3"   = "audio/mpeg"
    ".wav"   = "audio/wav"
    ".pdf"   = "application/pdf"
    ".txt"   = "text/plain; charset=utf-8"
}

$listener = New-Object System.Net.HttpListener
$prefix = "http://localhost:$Port/"
$listener.Prefixes.Add($prefix)

try {
    $listener.Start()
    Write-Host "=========================================="
    Write-Host "  KASSIA Local Server Started"
    Write-Host "  URL: $prefix"
    Write-Host "  Root: $root"
    Write-Host "=========================================="

    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response

        $rawUrl = $request.Url.AbsolutePath
        $decodedUrl = [System.Uri]::UnescapeDataString($rawUrl).TrimStart('/')
        
        if ([string]::IsNullOrWhiteSpace($decodedUrl)) {
            $decodedUrl = "index.html"
        } elseif ($decodedUrl.EndsWith('/')) {
            $decodedUrl = $decodedUrl + "index.html"
        }

        $decodedUrl = $decodedUrl -replace '/', [System.IO.Path]::DirectorySeparatorChar
        $filePath = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($root, $decodedUrl))

        if ($filePath.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase) -and (Test-Path $filePath -PathType Leaf)) {
            $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
            $contentType = if ($mimeTypes.ContainsKey($ext)) { $mimeTypes[$ext] } else { "application/octet-stream" }
            $response.ContentType = $contentType
            $response.StatusCode = 200

            try {
                $fileBytes = [System.IO.File]::ReadAllBytes($filePath)
                $response.ContentLength64 = $fileBytes.Length
                $response.OutputStream.Write($fileBytes, 0, $fileBytes.Length)
            } catch {
                $response.StatusCode = 500
            }
        } else {
            $response.StatusCode = 404
            $notFoundBytes = [System.Text.Encoding]::UTF8.GetBytes("<html><body><h1>404 Not Found</h1><p>The requested file $decodedUrl was not found.</p></body></html>")
            $response.ContentType = "text/html; charset=utf-8"
            $response.ContentLength64 = $notFoundBytes.Length
            $response.OutputStream.Write($notFoundBytes, 0, $notFoundBytes.Length)
        }

        try {
            $response.OutputStream.Close()
        } catch {}
    }
} catch {
    Write-Error $_
} finally {
    if ($listener.IsListening) {
        $listener.Stop()
    }
    $listener.Close()
}
