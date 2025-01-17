<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Tables</title>
</head>
<body>
    <h1>All Tables Data</h1>
    @foreach ($data as $table => $rows)
        <h2>{{ ucfirst($table) }}</h2>
        <table border="1">
            <thead>
                <tr>
                    @foreach (array_keys($rows->first()->toArray()) as $column)
                        <th>{{ $column }}</th>
                    @endforeach
                </tr>
            </thead>
            <tbody>
                @foreach ($rows as $row)
                    <tr>
                        @foreach ($row->toArray() as $value)
                            <td>{{ $value }}</td>
                        @endforeach
                    </tr>
                @endforeach
            </tbody>
        </table>
    @endforeach
</body>
</html>
