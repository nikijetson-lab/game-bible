# Lightweight PowerShell Web Server for game-bible
# Runs a local HTTP server on http://localhost:8000 without requiring Python or Node.js!

$port = 8000
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")

try {
    $listener.Start()
    Write-Host "==========================================================" -ForegroundColor Cyan
    Write-Host "ПОРТАЛ БЛІДОГО ВАРТІВНИКА — ЛОКАЛЬНИЙ СЕРВЕР ЗАПУЩЕНО!" -ForegroundColor Green
    Write-Host "Адреса гри: http://localhost:$port/web/" -ForegroundColor Yellow
    Write-Host "Для зупинки сервера натисніть Ctrl+C у цьому вікні." -ForegroundColor Gray
    Write-Host "==========================================================" -ForegroundColor Cyan
} catch {
    Write-Host "Помилка запуску сервера: $_" -ForegroundColor Red
    Exit
}

# Map file extensions to Content-Type headers
$mimeTypes = @{
    ".html" = "text/html; charset=utf-8"
    ".css"  = "text/css; charset=utf-8"
    ".js"   = "application/javascript; charset=utf-8"
    ".md"   = "text/markdown; charset=utf-8"
    ".png"  = "image/png"
    ".jpg"  = "image/jpeg"
    ".jpeg" = "image/jpeg"
    ".ico"  = "image/x-icon"
}

$repoRoot = Get-Item $PSScriptRoot

while ($listener.IsListening) {
    try {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        $urlPath = [Uri]::UnescapeDataString($request.Url.AbsolutePath)
        
        # Default route
        if ($urlPath -eq "/" -or $urlPath -eq "") {
            $urlPath = "/web/index.html"
        }
        
        # Construct absolute path on filesystem
        # Remove leading slash and convert slashes to windows path
        $relPath = $urlPath.TrimStart('/')
        $localFilePath = Join-Path $repoRoot.FullName $relPath
        
        # Security check: ensure path is within repo root
        $resolvedPath = [System.IO.Path]::GetFullPath($localFilePath)
        if (-not $resolvedPath.StartsWith($repoRoot.FullName)) {
            $response.StatusCode = 403
            $response.Close()
            continue
        }
        
        # Check if file exists
        if (Test-Path $resolvedPath -PathType Leaf) {
            $ext = [System.IO.Path]::GetExtension($resolvedPath).ToLower()
            $contentType = $mimeTypes[$ext]
            if ($null -eq $contentType) {
                $contentType = "application/octet-stream"
            }
            
            $response.ContentType = $contentType
            $bytes = [System.IO.File]::ReadAllBytes($resolvedPath)
            $response.ContentLength64 = $bytes.Length
            $response.OutputStream.Write($bytes, 0, $bytes.Length)
            $response.StatusCode = 200
        } else {
            # File not found
            $response.StatusCode = 404
            $errorMsg = [System.Text.Encoding]::UTF8.GetBytes("404 File Not Found: $urlPath")
            $response.ContentType = "text/plain; charset=utf-8"
            $response.ContentLength64 = $errorMsg.Length
            $response.OutputStream.Write($errorMsg, 0, $errorMsg.Length)
        }
        
        $response.Close()
    } catch {
        # Silent fail or exit on shutdown
        if ($listener.IsListening) {
            # Write-Host "Error handling request: $_" -ForegroundColor Red
        }
    }
}
